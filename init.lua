vim.loader.enable()
vim.g.mapleader = ' ' -- Set <space> as the leader keyinit  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.opt.number = false -- Make line numbers off by default, can set on when needed with :set number
vim.opt.showmode = false -- Don't show the mode, since it's already in the status line
vim.opt.winborder = 'rounded'
vim.opt.wrap = false
vim.opt.clipboard = 'unnamedplus' --  Remove this option if you want your OS clipboard to remain independent.
vim.opt.breakindent = true
vim.opt.undofile = true -- Save undo history
vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250 -- Decrease update time
vim.opt.timeout = false -- Never time out on mapped sequences so you can type as slow as you want for chords like <leader>sP
vim.opt.splitright = true -- Configure how new splits should be opened
vim.opt.list = true --  See `:help 'list'`
vim.opt.listchars = { tab = '» ', trail = ' ', nbsp = '␣' } --  See `:help 'listchars'`
vim.opt.inccommand = 'split' -- Preview substitutions live, as you type!
vim.opt.fillchars = { eob = ' ' } -- Stop neovim from showing "~" on the start of every row after the last line in the file
vim.opt.cursorline = true -- Show which line your cursor is on
vim.opt.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.cmdheight = 0 -- By default it shows you the last command you typed. By having this off the statusline sits at the very bottom right
vim.opt.hlsearch = true -- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.foldtext = 'v:lua.vim.treesitter.foldtext()'

require('custom.theme').setup()
require('custom.statusline').setup()
require('custom.todo-highlights').setup()
require('custom.format').setup()
require('custom.gutter-marks').setup()
require('custom.sleuth').setup()
require('custom.autoclose').setup()

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'csv',
  desc = 'Enable CSV View on .csv files',
  callback = function() require('csvview').enable() end,
})

-- Treesitter build hook (must be before vim.pack.add)
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' then
      if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
      vim.cmd 'TSUpdate'
    end
  end,
})

-- [[ Install plugins with vim.pack (Neovim 0.12 built-in package manager) ]]
--    See `:help vim.pack` for more info
--    Update plugins with `:lua vim.pack.update()`
--    Plugin configs are in plugin/*.lua (auto-sourced after init.lua)
vim.pack.add {
  'https://github.com/folke/snacks.nvim',
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.x' }, -- use a release tag to download pre-built binaries
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/folke/lazydev.nvim', -- configures Lua LSP for your Neovim config, runtime and plugins
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' }, -- functions for installing, updating, and removing tree-sitter parsers
  'https://github.com/folke/flash.nvim',
  'https://github.com/echasnovski/mini.files',
  'https://github.com/echasnovski/mini.ai', -- Better Around/Inside textobjects
  'https://github.com/echasnovski/mini.surround', -- Add/delete/replace surroundings (brackets, quotes, etc.)
  'https://github.com/sindrets/diffview.nvim', -- Diff integration
  'https://github.com/MagicDuck/grug-far.nvim',
  'https://github.com/hat0uma/csvview.nvim',
}

-- Better Around/Inside textobjects
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [']quote
--  - ci'  - [C]hange [I]nside [']quote
require('mini.ai').setup { n_lines = 500 }

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--  - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
--  - sd'   - [S]urround [D]elete [']quotes
--  - sr)'  - [S]urround [R]eplace [)] [']
require('mini.surround').setup {}

-- Treesitter parser installation
require('nvim-treesitter').install {
  'bash',
  'c',
  'html',
  'css',
  'lua',
  'luadoc',
  'sql',
  'json',
  'terraform',
  'rust',
  'markdown',
  'vim',
  'vimdoc',
  'just',
  'elixir',
  'typescript',
  'tsx',
  'javascript',
}

-- The main branch of nvim-treesitter is just a parser manager;
-- it no longer auto-enables highlighting. Enable it for all filetypes with a parser.
vim.api.nvim_create_autocmd('FileType', { callback = function() pcall(vim.treesitter.start) end })

-- 'vim.lsp.enable' tells neovim to start the LSP when it sees a matching filetype
-- to see active/enabled LSPs and their config run :LspInfo
-- this does *not* auto install LSPs, Use mise-en-place outside of neovim to install
vim.lsp.enable 'bashls'
vim.lsp.enable 'ts_go_ls'
vim.lsp.enable 'gleam'
vim.lsp.enable 'rust_analyzer'
vim.lsp.enable 'pyright'
vim.lsp.enable 'html'
vim.lsp.enable 'lua_ls'
vim.lsp.enable 'terraformls'

vim.api.nvim_set_keymap('n', '<Leader>w', '<C-w>', { desc = '[W]indow management' })
vim.keymap.set('n', '<leader>lh', vim.lsp.buf.hover, { desc = '[L]anguage [H]over' })
vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float, { desc = '[L]anguage [E]rror' })
vim.keymap.set('n', '<leader>lrn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })
vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { desc = '[L]anguage [A]ction' })

vim.keymap.set('n', '<leader>lrb', function()
  vim.cmd ':lsp disable'
  vim.cmd ':w'
  vim.cmd ':e' -- refresh the buffer re-triggers LSPs to start
end, { desc = '[L]anguage [R]e[B]oot' })

vim.api.nvim_create_user_command('LspInfo', function() vim.cmd 'checkhealth vim.lsp' end, { desc = 'Show LSP info via checkhealth' })

vim.filetype.add {
  extension = {
    env = 'sh',
    zsh = 'sh',
    sh = 'sh', -- force sh-files with zsh-shebang to still get sh as filetype
  },
  filename = {
    ['.zshrc'] = 'sh',
    ['.zshenv'] = 'sh',
  },
}

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', 'q', '<cmd>echo "disabled q to stop recording mishaps"<CR>')

local function normal_and_visual_keymap(letter, mapping, desc)
  vim.keymap.set('n', letter, mapping, { desc = desc })
  vim.keymap.set('v', letter, mapping, { desc = desc })
end
normal_and_visual_keymap('J', '10j', 'Jump 10 down')
normal_and_visual_keymap('K', '10k', 'Jump 10 up')
normal_and_visual_keymap('H', '^', 'Jump to start of line')
normal_and_visual_keymap('L', '$', 'Jump to end of line')
normal_and_visual_keymap('p', 'P', 'Make paste leave clipboard alone')
normal_and_visual_keymap('c', '"ac', 'Make change leave clipboard alone')
normal_and_visual_keymap('x', '"_x', 'Make delete 1 character leave clipboard alone')
vim.api.nvim_set_keymap('n', 'z', '<C-o>', {})
vim.api.nvim_set_keymap('n', 'Z', '<C-i>', {})

vim.keymap.set('n', 'cx', 'r') -- keep all changes under c
vim.keymap.set('c', 'Q', 'q') -- fix typos of Capital Q
