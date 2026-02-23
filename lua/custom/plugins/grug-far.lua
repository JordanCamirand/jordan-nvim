--- Util functions stolen from grug-far for getting visual selection

--- leave visual mode if in visual mode
---@return boolean if left visual mode
local function leaveVisualMode()
  local isVisualMode = vim.fn.mode():lower():find 'v' ~= nil
  if isVisualMode then
    -- needed to make visual selection work
    -- without this, we will get the *last* visual selection and not the current
    vim.fn.feedkeys(':', 'nx')
  end
  return isVisualMode
end

--- get text lines in visual selection
--- range row are 1-based, col are 0-based
---@return string[] lines, integer start_row, integer start_col, integer end_row, integer end_col
local function getVisualSelectionLines()
  leaveVisualMode()
  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, '<'))
  if not start_col then start_col = 0 end

  local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, '>'))
  if not end_col then end_col = -1 end
  if end_col > 0 then
    end_col = end_col + 1 -- this is necessary due to end mark not being after the selection
  end

  local first_line = unpack(vim.api.nvim_buf_get_lines(0, start_row - 1, start_row, true))
  if first_line and start_col > #first_line then start_col = #first_line end
  local last_line = unpack(vim.api.nvim_buf_get_lines(0, end_row - 1, end_row, true))
  if last_line and end_col > #last_line then end_col = -1 end

  local lines = vim.api.nvim_buf_get_text(0, start_row - 1, start_col, end_row - 1, end_col, {})

  return lines, start_row, start_col, end_row, end_col
end

return {
  'MagicDuck/grug-far.nvim',
  keys = {
    {
      '<leader>ir',
      mode = { 'n' },
      function() require('grug-far').open() end,
      desc = '[I]ntegrated [R]eplace',
    },
    {
      '<leader>ir',
      mode = { 'v' },
      function()
        local selectedText = getVisualSelectionLines()
        local mergedSelectedText = table.concat(selectedText, '\n')
        require('grug-far').with_visual_selection { prefills = { paths = vim.fn.expand '%', replacement = mergedSelectedText } }
      end,
      desc = '[I]ntegrated [R]eplace',
    },
  },
  config = function()
    require('grug-far').setup {
      windowCreationCommand = 'tabnew %',
    }
  end,
}
