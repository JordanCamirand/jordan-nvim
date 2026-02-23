-- Replacing todo-comments.nvim
-- Highlights TODO, FIXME, etc. keywords in comments
-- original had treesitter use but decided to simplify here to just regex
-- Original also had lots of picker integrations and quickfix integration that I don't care about

local M = {}
local ns = vim.api.nvim_create_namespace 'todo-highlights'

local keywords = {
  FIX = { color = 'DiagnosticError', alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' } },
  TODO = { color = 'DiagnosticInfo' },
  HACK = { color = 'DiagnosticWarn' },
  WARN = { color = 'DiagnosticWarn', alt = { 'WARNING', 'XXX' } },
  PERF = { color = 'DiagnosticHint', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
  NOTE = { color = 'DiagnosticHint', alt = { 'INFO' } },
  TEST = { color = 'DiagnosticHint', alt = { 'TESTING', 'PASSED', 'FAILED' } },
}

local kw_lookup = {}
local names = {}
for kw, def in pairs(keywords) do
  kw_lookup[kw] = kw
  names[#names + 1] = kw
  for _, alt in ipairs(def.alt or {}) do
    kw_lookup[alt] = kw
    names[#names + 1] = alt
  end
end
table.sort(names, function(a, b) return #a > #b end)
-- Match keyword after a comment prefix (// or # or --)
local pattern = [[\v\C(\/\/|#|--).*(]] .. table.concat(names, '|') .. [[)\s*:]]

local function setup_highlights()
  for kw, def in pairs(keywords) do
    local fg = (vim.api.nvim_get_hl(0, { name = def.color, link = false })).fg
    vim.api.nvim_set_hl(0, 'TodoBg' .. kw, { bg = fg, fg = 'bg', bold = true })
    vim.api.nvim_set_hl(0, 'TodoFg' .. kw, { fg = fg })
  end
end

local function highlight_range(buf, first, last)
  vim.api.nvim_buf_clear_namespace(buf, ns, first, last + 1)
  for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, first, last + 1, false)) do
    local m = vim.fn.matchlist(line, pattern)
    if #m >= 3 and m[3] ~= '' then
      local lnum = first + i - 1
      local kw = kw_lookup[m[3]]
      local col = line:find(m[3], 1, true) - 1
      local fin = col + #m[3]
      vim.api.nvim_buf_set_extmark(buf, ns, lnum, math.max(col - 1, 0), { end_col = math.min(fin + 1, #line), hl_group = 'TodoBg' .. kw })
      if fin < #line then vim.api.nvim_buf_set_extmark(buf, ns, lnum, fin, { end_col = #line, hl_group = 'TodoFg' .. kw }) end
    end
  end
end

function M.setup()
  setup_highlights()
  vim.api.nvim_set_decoration_provider(ns, {
    on_win = function(_, _, buf, toprow, botrow)
      if vim.bo[buf].buftype ~= '' then return false end
      highlight_range(buf, toprow, botrow)
    end,
  })
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.api.nvim_create_augroup('todo-highlights', { clear = true }),
    callback = setup_highlights,
  })
end

return M
