---@module 'flash'
---@type Flash.Config
require('flash').setup {
  modes = {
    char = {
      enabled = false,
    },
    search = {
      enabled = true,
      multi_window = false,
    },
  },
  label = {
    rainbow = {
      enabled = false,
      -- number between 1 and 9
      shade = 9,
    },
  },
}

vim.keymap.set({ 'n', 'x', 'o' }, 'S', function() require('flash').treesitter() end, { desc = 'Flash Treesitter' })
vim.keymap.set('o', 'r', function() require('flash').remote() end, { desc = 'Remote Flash' })
vim.keymap.set({ 'n', 'o', 'x' }, '/', function() require('flash').jump() end, { desc = 'Treesitter Search' })
