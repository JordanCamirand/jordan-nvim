-- lazy.nvim
return {
  'robitx/gp.nvim',
  config = function()
    local conf = {
      providers = {
        anthropic = {
          endpoint = 'https://api.anthropic.com/v1/messages',
          secret = os.getenv 'ANTHROPIC_API_KEY',
        },
      },

      -- For customization, refer to Install > Configuration in the Documentation/Readme
    }
    require('gp').setup(conf)

    -- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
  end,
}
