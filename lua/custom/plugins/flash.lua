return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  ---@module 'flash'
  ---@type Flash.Config
  opts = {},
  -- stylua: ignore
  search = {
    multi_window = false
  },
  keys = {
    -- { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    {
      'S',
      mode = { 'n', 'x', 'o' },
      function() require('flash').treesitter() end,
      desc = 'Flash Treesitter',
    },
    {
      'r',
      mode = 'o',
      function() require('flash').remote() end,
      desc = 'Remote Flash',
    },
    {
      '/',
      mode = { 'n', 'o', 'x' },
      function() require('flash').jump() end,
      desc = 'Treesitter Search',
    },
  },
  config = {
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
  },
}
