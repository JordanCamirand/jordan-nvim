-- Replacing lualine
-- Shows right-aligned relative filepath with modified/readonly indicators

local M = {}

function M.render()
  local ft = vim.bo.filetype
  if ft == 'minintro' then return '' end

  local path = vim.fn.expand '%:~:.'
  if path == '' then path = '[No Name]' end

  -- Escape % characters in path for statusline
  path = path:gsub('%%', '%%%%')
  return '%=' .. path .. ' '
end

function M.setup()
  vim.opt.laststatus = 2
  vim.o.statusline = "%{%v:lua.require'custom.statusline'.render()%}"
end

return M
