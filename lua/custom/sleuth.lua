-- Replacing vim-sleuth
-- Auto-detects shiftwidth/tabstop/expandtab by inspecting buffer contents

local M = {}

function M.detect(bufnr)
  bufnr = bufnr or 0
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, math.min(256, vim.api.nvim_buf_line_count(bufnr)), false)

  local tab_count = 0
  local space_count = 0
  local indent_widths = {}

  for _, line in ipairs(lines) do
    if line == '' then goto continue end
    local tabs = line:match '^(\t+)'
    if tabs then
      tab_count = tab_count + 1
      goto continue
    end
    local spaces = line:match '^( +)%S'
    if spaces then
      space_count = space_count + 1
      local w = #spaces
      if w >= 2 and w <= 8 then
        indent_widths[w] = (indent_widths[w] or 0) + 1
      end
    end
    ::continue::
  end

  if tab_count == 0 and space_count == 0 then return end

  if tab_count > space_count then
    vim.bo[bufnr].expandtab = false
    return
  end

  -- Find the most likely indent width (smallest with high frequency)
  local best_width = nil
  local best_score = 0
  for w = 2, 8 do
    local count = indent_widths[w] or 0
    -- Count lines whose indent is a multiple of w
    local divisible = 0
    for width, c in pairs(indent_widths) do
      if width % w == 0 then divisible = divisible + c end
    end
    if divisible > best_score then
      best_score = divisible
      best_width = w
    elseif divisible == best_score and count > 0 and (best_width == nil or w < best_width) then
      best_width = w
    end
  end

  if best_width then
    vim.bo[bufnr].expandtab = true
    vim.bo[bufnr].shiftwidth = best_width
    vim.bo[bufnr].tabstop = best_width
  end
end

function M.setup()
  vim.api.nvim_create_autocmd('BufReadPost', {
    group = vim.api.nvim_create_augroup('custom-sleuth', { clear = true }),
    callback = function(args) M.detect(args.buf) end,
  })
end

return M
