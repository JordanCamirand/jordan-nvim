return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  ---@type Flash.Config
  opts = {
    search = {
      -- search/jump in all windows
      multi_window = false,
    },
  },
  -- stylua: ignore
  keys = {
    -- { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
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
