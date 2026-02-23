-- to get typescript-go lsp installed and working (make sure you have golang 1.25 installed):
-- git clone --recursive --depth 1 https://github.com/microsoft/typescript-go.git
-- cd typescript-go
-- npm ci
-- npm run build

---@type vim.lsp.Config
return {
  cmd = { '/Users/jordan/code/personal/typescript-go/built/local/tsgo', '--lsp', '-stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
}
