return {
  'MagicDuck/grug-far.nvim',
  commit = '6ef402861468c6bd987155be17a34ba4291dc1d0',
  keys = {

    {
      '<leader>ir',
      mode = { 'n' },
      function()
        require('grug-far').open()
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
