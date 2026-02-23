-- Replacing gitsigns gutter marks
-- Shows +/~/_ signs in the gutter for git added/changed/deleted lines
-- Uses vim.diff() and extmarks instead of the gitsigns plugin

local api = vim.api
local M = {}
local ns = api.nvim_create_namespace 'gutter-marks'

local sign_map = {
  add = { text = '+', hl = 'Added' },
  change = { text = '~', hl = 'Changed' },
  delete = { text = '_', hl = 'Removed' },
  topdelete = { text = '‾', hl = 'Removed' },
  changedelete = { text = '~', hl = 'Changed' },
}

local function git_file_content(bufnr)
  local filepath = api.nvim_buf_get_name(bufnr)
  if filepath == '' then return nil end

  local dir = vim.fn.fnamemodify(filepath, ':h')
  local toplevel = vim.fn.systemlist { 'git', '-C', dir, 'rev-parse', '--show-toplevel' }
  if vim.v.shell_error ~= 0 or #toplevel == 0 then return nil end

  local relpath = vim.fn.fnamemodify(filepath, ':.' .. toplevel[1])
  -- Get the file from git index
  local result = vim.fn.systemlist { 'git', '-C', toplevel[1], 'show', ':' .. relpath }
  if vim.v.shell_error ~= 0 then return nil end
  return table.concat(result, '\n') .. '\n'
end

local function update_signs(bufnr)
  if not api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].buftype ~= '' then return end

  api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  local git_text = git_file_content(bufnr)
  if not git_text then return end

  local buf_lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local buf_text = table.concat(buf_lines, '\n') .. '\n'

  local hunks = vim.diff(git_text, buf_text, {
    result_type = 'indices',
    algorithm = 'histogram',
  })

  if not hunks then return end

  for _, hunk in ipairs(hunks) do
    local old_count, new_start, new_count = hunk[2], hunk[3], hunk[4]

    if new_count == 0 then
      -- Pure delete: place sign on the line above (or line 1)
      local lnum = math.max(new_start - 1, 0)
      local sign = new_start == 0 and sign_map.topdelete or sign_map.delete
      api.nvim_buf_set_extmark(bufnr, ns, lnum, 0, {
        sign_text = sign.text,
        sign_hl_group = sign.hl,
        priority = 100,
      })
    elseif old_count == 0 then
      -- Pure add
      for lnum = new_start - 1, new_start + new_count - 2 do
        api.nvim_buf_set_extmark(bufnr, ns, lnum, 0, {
          sign_text = sign_map.add.text,
          sign_hl_group = sign_map.add.hl,
          priority = 100,
        })
      end
    else
      -- Change: min(old, new) lines are changed, rest are adds or deletes
      local changed = math.min(old_count, new_count)
      for i = 0, changed - 1 do
        local sign = (i == changed - 1 and old_count > new_count) and sign_map.changedelete or sign_map.change
        api.nvim_buf_set_extmark(bufnr, ns, new_start - 1 + i, 0, {
          sign_text = sign.text,
          sign_hl_group = sign.hl,
          priority = 100,
        })
      end
      -- Extra added lines beyond the change
      for i = changed, new_count - 1 do
        api.nvim_buf_set_extmark(bufnr, ns, new_start - 1 + i, 0, {
          sign_text = sign_map.add.text,
          sign_hl_group = sign_map.add.hl,
          priority = 100,
        })
      end
    end
  end
end

function M.setup()
  local group = api.nvim_create_augroup('gutter-marks', { clear = true })

  api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost' }, {
    group = group,
    callback = function(ev) update_signs(ev.buf) end,
  })

  -- api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
  --   group = group,
  --   callback = function(ev)
  --     -- Debounce: defer so rapid typing doesn't shell out on every keystroke
  --     vim.defer_fn(function()
  --       if api.nvim_buf_is_valid(ev.buf) then
  --         update_signs(ev.buf)
  --       end
  --     end, 300)
  --   end,
  -- })

  -- Update all existing buffers
  for _, buf in ipairs(api.nvim_list_bufs()) do
    if api.nvim_buf_is_loaded(buf) then update_signs(buf) end
  end
end

return M
