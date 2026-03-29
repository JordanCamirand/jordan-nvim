-- File explorer
require('mini.files').setup {
  content = {
    filter = nil,
    prefix = nil,
    sort = nil,
  },
  mappings = {
    close = 'q',
    go_in = 'l',
    go_in_plus = 'L',
    go_out = 'h',
    go_out_plus = 'H',
    reset = '<BS>',
    reveal_cwd = '@',
    show_help = 'g?',
    synchronize = '=',
    trim_left = '<',
    trim_right = '>',
  },
  options = {
    permanent_delete = true,
    use_as_default_explorer = true,
  },
  windows = {
    max_number = 3,
    preview = true,
    width_focus = 30,
    width_nofocus = 15,
    width_preview = 100,
  },
}

vim.keymap.set('n', '<leader>if', function()
  local function file_exists(file)
    local f = io.open(file, 'rb')
    if f then f:close() end
    return f ~= nil
  end

  local filename = vim.api.nvim_buf_get_name(0)

  if file_exists(filename) then
    MiniFiles.open(filename)
  else
    MiniFiles.open()
  end
end, { desc = '[I]ntegrated [F]ile explorer (Current file)' })
