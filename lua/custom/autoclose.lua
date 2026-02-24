-- Replacing autoclose.nvim
-- Auto-closes brackets, quotes, etc.

local M = {}

local pairs_map = {
  ['('] = ')',
  ['['] = ']',
  ['{'] = '}',
  ['"'] = '"',
  ["'"] = "'",
  ['`'] = '`',
}

local function get_char_at_cursor()
  local col = vim.fn.col '.'
  local line = vim.fn.getline '.'
  return line:sub(col, col)
end

function M.setup()
  local group = vim.api.nvim_create_augroup('custom-autoclose', { clear = true })

  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    callback = function(args)
      local bufnr = args.buf

      for open, close in pairs(pairs_map) do
        if open == close then
          -- Quote-like: insert pair only if not already on the same quote
          vim.keymap.set('i', open, function()
            local char_after = get_char_at_cursor()
            if char_after == open then
              return '<Right>'
            end
            return open .. close .. '<Left>'
          end, { buffer = bufnr, expr = true })
        else
          -- Bracket-like: always insert pair
          vim.keymap.set('i', open, function()
            return open .. close .. '<Left>'
          end, { buffer = bufnr, expr = true })

          -- Skip closing char if already present
          vim.keymap.set('i', close, function()
            local char_after = get_char_at_cursor()
            if char_after == close then
              return '<Right>'
            end
            return close
          end, { buffer = bufnr, expr = true })
        end
      end

      -- Backspace: delete pair if cursor is between matching pair
      vim.keymap.set('i', '<BS>', function()
        local col = vim.fn.col '.'
        local line = vim.fn.getline '.'
        local before = line:sub(col - 1, col - 1)
        local after = line:sub(col, col)
        if pairs_map[before] == after then
          return '<BS><Del>'
        end
        return '<BS>'
      end, { buffer = bufnr, expr = true })
    end,
  })
end

return M
