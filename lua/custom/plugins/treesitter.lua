return {
  -- functions for installing, updating, and removing tree-sitter parsers;
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').install {
      'bash',
      'c',
      'html',
      'css',
      'lua',
      'luadoc',
      'markdown',
      'vim',
      'vimdoc',
      'just',
      'elixir',
      'typescript',
      'tsx',
      'javascript',
    }
  end,
}
