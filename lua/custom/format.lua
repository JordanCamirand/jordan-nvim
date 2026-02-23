-- Replacing conform.nvim with simpler version
-- Conform has async formatting but sync is fine when using a fast formatter like oxfmt
-- Conform also has fallbacks / formatter chains, ability to format only a visually selected part, etc
-- Runs CLI formatters via stdin/stdout, falls back to LSP

local M = {}

-- Each entry: { cmd, args... } where cmd can be a node_modules binary
-- Use $FILENAME as a placeholder for the buffer's file path
local formatters_by_ft = {
  lua = { 'stylua', '-' },
  rust = { 'rustfmt' },
  javascript = { 'oxfmt', '--stdin-filepath', '$FILENAME' },
  javascriptreact = { 'oxfmt', '--stdin-filepath', '$FILENAME' },
  typescript = { 'oxfmt', '--stdin-filepath', '$FILENAME' },
  typescriptreact = { 'oxfmt', '--stdin-filepath', '$FILENAME' },
}

-- Search upward from dir for node_modules/.bin/<cmd>
local function find_in_node_modules(cmd, dir)
  local results = vim.fs.find('node_modules', { upward = true, path = dir, type = 'directory', limit = math.huge })
  for _, node_modules in ipairs(results) do
    local fullpath = node_modules .. '/.bin/' .. cmd
    if vim.fn.executable(fullpath) == 1 then return fullpath end
  end
  return nil
end

local function get_cmd(bufnr)
  local ft = vim.bo[bufnr].filetype
  local spec = formatters_by_ft[ft]
  if not spec then return nil end

  local filename = vim.api.nvim_buf_get_name(bufnr)
  local dir = vim.fn.fnamemodify(filename, ':h')
  local cmd_name = spec[1]

  -- Resolve command: try node_modules first, then PATH
  local cmd_path = find_in_node_modules(cmd_name, dir)
  if not cmd_path then
    if vim.fn.executable(cmd_name) == 1 then
      cmd_path = cmd_name
    else
      return nil
    end
  end

  local resolved = { cmd_path }
  for i = 2, #spec do
    local arg = spec[i]
    table.insert(resolved, arg == '$FILENAME' and filename or arg)
  end
  return resolved
end

function M.format(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local cmd = get_cmd(bufnr)

  if not cmd then return end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local input = table.concat(lines, '\n') .. '\n'

  local result = vim.system(cmd, { stdin = input }):wait()
  if result.code ~= 0 then
    -- vim.notify('Format failed: ' .. (result.stderr or ''), vim.log.levels.WARN)
    return
  end

  local output = result.stdout
  if not output or output == '' then return end

  -- Strip trailing newline to match buffer representation
  if output:sub(-1) == '\n' then output = output:sub(1, -2) end

  local new_lines = vim.split(output, '\n')

  -- Apply minimal diff to preserve marks, folds, and undo history
  local old_text = input
  local new_text = output .. '\n'
  local hunks = vim.diff(old_text, new_text, { result_type = 'indices' })
  if #hunks == 0 then return end

  -- Save cursor position and compute line offset from hunks above cursor
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_line = cursor[1]
  local line_offset = 0

  for i = #hunks, 1, -1 do
    local old_start, old_count, new_start, new_count = unpack(hunks[i])
    local replacement = {}
    for j = new_start, new_start + new_count - 1 do
      table.insert(replacement, new_lines[j])
    end
    vim.api.nvim_buf_set_lines(bufnr, old_start - 1, old_start - 1 + old_count, false, replacement)

    -- Track how hunks above the cursor shift line numbers
    if old_start < cursor_line then line_offset = line_offset + (new_count - old_count) end
  end

  -- Restore cursor, clamped to valid range
  local new_line = math.max(1, math.min(cursor_line + line_offset, vim.api.nvim_buf_line_count(bufnr)))
  local line_text = vim.api.nvim_buf_get_lines(bufnr, new_line - 1, new_line, false)[1] or ''
  local new_col = math.min(cursor[2], #line_text)
  vim.api.nvim_win_set_cursor(0, { new_line, new_col })
end

function M.setup()
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('custom-format', { clear = true }),
    callback = function(args) M.format(args.buf) end,
  })
end

return M
