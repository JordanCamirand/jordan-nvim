-- Global bookmark list PER repo. Sounds weird but that way you can do whatever shenanigans with multiple clones of the same repo and it will work
local function open_bookmarks()
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.shellescape(vim.fn.expand '%:p:h') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 or not git_root then
    vim.notify('Not in a git repo', vim.log.levels.WARN)
    return
  end
  local repo_name = vim.fn.fnamemodify(git_root, ':t')
  local bookmarks_file = vim.fn.expand('~/jordan-nvim-bookmarks/' .. repo_name .. '-bookmark.txt')

  if vim.fn.filereadable(bookmarks_file) == 0 then
    vim.fn.mkdir(vim.fn.expand '~/jordan-nvim-bookmarks', 'p')
    vim.fn.writefile({}, bookmarks_file)
  end

  Snacks.picker.pick {
    title = repo_name .. ' Bookmarks',
    finder = function()
      local lines = vim.fn.readfile(bookmarks_file)
      local items = {}
      for _, line in ipairs(lines) do
        if line ~= '' then
          local sep_pos = line:find ';'
          if sep_pos then
            local description = line:sub(1, sep_pos - 1)
            local path = line:sub(sep_pos + 1)
            if not path:match '^[~/]' then path = git_root .. '/' .. path end
            table.insert(items, {
              text = description,
              file = vim.fn.expand(path),
              pos = { 1, 0 },
            })
          else
            local path = line
            if not path:match '^[~/]' then path = git_root .. '/' .. path end
            table.insert(items, {
              text = line,
              file = vim.fn.expand(path),
              pos = { 1, 0 },
            })
          end
        end
      end
      table.insert(items, {
        text = repo_name .. '-bookmark.txt',
        file = bookmarks_file,
        pos = { 1, 0 },
      })
      return items
    end,
    format = 'text',
  }
end

local function paste_file_path()
  Snacks.picker.files {
    hidden = true,
    confirm = function(picker, item)
      picker:close()
      if item then vim.api.nvim_put({ item.file }, '', true, true) end
    end,
  }
end

local function open_toolbox()
  local commands = {
    {
      name = 'Copy relative path to clipboard',
      execute = function()
        local path = vim.fn.expand '%'
        vim.fn.setreg('+', path)
      end,
    },
    { name = 'Git blame', execute = 'Gitsigns blame' },
    { name = 'Git revert/reset hunk', execute = 'Gitsigns reset_hunk' },
    { name = 'Git revert/reset buffer', execute = 'Gitsigns reset_buffer' },
    { name = 'Git stash search', execute = 'lua Snacks.picker.git_stash()' },
    { name = 'Scratch buffer', execute = 'lua Snacks.scratch()' },
    { name = 'Search Commands', execute = 'lua Snacks.picker.commands()' },
    { name = 'Search text no regex', execute = 'lua Snacks.picker.grep({regex = false})' },
    {
      name = 'Copy absolute path to clipboard',
      execute = function()
        local path = vim.fn.expand '%:p'
        vim.fn.setreg('+', path)
      end,
    },
  }

  Snacks.picker.pick {
    title = 'Toolbox',
    layout = { preset = 'select' },
    finder = function()
      local items = {}
      for idx, cmd in ipairs(commands) do
        table.insert(items, {
          text = cmd.name,
          idx = idx,
          cmd = cmd,
        })
      end
      return items
    end,
    format = 'text',
    confirm = function(picker, item)
      picker:close()
      if item then
        local exec = item.cmd.execute
        if type(exec) == 'function' then
          exec()
        else
          vim.cmd(exec)
        end
      end
    end,
  }
end

---@module 'snacks'
---@type snacks.Config
require('snacks').setup {
  bigfile = { enabled = true },
  dashboard = {
    enabled = true,
    preset = {
      keys = {},
      header = (function()
        -- Use os.date('*t') to get local time, which respects system timezone/DST
        local est = os.date '*t'
        local hour = est.hour
        local ampm = hour >= 12 and 'PM' or 'AM'
        local h12 = hour % 12
        if h12 == 0 then h12 = 12 end
        local min = est.min

        local R = 8
        local PAD = 4
        local W = R * 4 + 1 + PAD * 2
        local H = R * 2 + 1 + PAD
        local cx, cy = R * 2 + PAD, R + 2
        local grid = {}
        for y = 0, H - 1 do
          grid[y] = {}
          for x = 0, W - 1 do
            grid[y][x] = ' '
          end
        end

        -- draw circle
        local nums = { '12', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11' }
        for i = 0, 59 do
          local angle = (i / 60) * 2 * math.pi - math.pi / 2
          local x = math.floor(cx + (R * 2) * math.cos(angle) + 0.5)
          local y = math.floor(cy + R * math.sin(angle) + 0.5)
          if x >= 0 and x < W and y >= 0 and y < H then
            if i % 5 == 0 then
              grid[y][x] = '●'
            elseif grid[y][x] == ' ' then
              grid[y][x] = '·'
            end
          end
        end

        -- place hour numbers
        for i, num in ipairs(nums) do
          local angle = ((i - 1) / 12) * 2 * math.pi - math.pi / 2
          local x = math.floor(cx + (R * 2 + 2) * math.cos(angle) + 0.5)
          local y = math.floor(cy + (R + 1) * math.sin(angle) + 0.5)
          if y >= 0 and y < H then
            if #num == 2 then
              if x - 1 >= 0 and x < W then
                grid[y][x - 1] = num:sub(1, 1)
                grid[y][x] = num:sub(2, 2)
              end
            else
              if x >= 0 and x < W then grid[y][x] = num end
            end
          end
        end

        -- draw hand
        local function draw_hand(angle, len, ch)
          for t = 1, len * 4 do
            local frac = t / (len * 4)
            local x = math.floor(cx + (len * 2) * frac * math.cos(angle) + 0.5)
            local y = math.floor(cy + len * frac * math.sin(angle) + 0.5)
            if x >= 0 and x < W and y >= 0 and y < H then grid[y][x] = ch end
          end
        end

        -- minute hand
        local min_angle = (min / 60) * 2 * math.pi - math.pi / 2
        draw_hand(min_angle, R - 1, '◦')

        -- hour hand
        local hour_angle = ((hour % 12 + min / 60) / 12) * 2 * math.pi - math.pi / 2
        draw_hand(hour_angle, R - 3, '•')

        -- center dot
        grid[cy][cx] = '◎'

        local lines = {}
        for y = 0, H - 1 do
          local row = {}
          for x = 0, W - 1 do
            table.insert(row, grid[y][x])
          end
          table.insert(lines, table.concat(row))
        end
        table.insert(lines, '')
        table.insert(lines, string.format('%d:%02d %s', h12, min, ampm))
        return table.concat(lines, '\n')
      end)(),
    },
    sections = {
      { section = 'header' },
    },
  },
  explorer = { enabled = true, replace_netrw = false },
  indent = { enabled = false },
  input = { enabled = true },
  picker = {
    enabled = true,
    matcher = { ignorecase = true },

    layout = { preset = 'telescope' },
    sources = {
      explorer = {
        auto_close = true,
        layout = {
          preview = 'main',
        },
      },
    },
    win = {
      preview = {
        wo = {
          number = false,
        },
      },
      input = {
        minimal = true,
      },
    },
  },
  notifier = { enabled = true },
  quickfile = { enabled = false },
  scratch = { enabled = true },
  scope = { enabled = false },
  scroll = { enabled = false },
  statuscolumn = { enabled = false },
  words = { enabled = false },
}

-- Top Pickers & Explorer
vim.keymap.set('n', '<leader><leader>', function() Snacks.picker.smart() end, { desc = 'Smart Find Files' })
vim.keymap.set('n', '<leader>sf', function() Snacks.picker.files { hidden = true } end, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>so', function() Snacks.picker.buffers() end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>sp', function() Snacks.picker.grep() end, { desc = 'Grep' })
vim.keymap.set('n', '<leader>sP', function() Snacks.picker.grep { regex = false } end, { desc = 'Grep ' })
vim.keymap.set('n', '<leader>sgs', function() Snacks.picker.git_status() end, { desc = '[G]it [S]tatus' })
vim.keymap.set('n', '<leader>sgh', function() Snacks.picker.gh_pr() end, { desc = 'Search GitHub' })
vim.keymap.set('n', '<leader>sb', function() Snacks.picker.lines() end, { desc = 'Buffer Lines' })
vim.keymap.set('n', '<leader>sc', function() Snacks.picker.commands() end, { desc = 'Commands' })
vim.keymap.set('n', '<leader>sd', function() Snacks.picker.diagnostics() end, { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, { desc = 'Buffer Diagnostics' })
vim.keymap.set('n', '<leader>sh', function() Snacks.picker.help() end, { desc = 'Help Pages' })
vim.keymap.set('n', '<leader>sk', function() Snacks.picker.keymaps() end, { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>sr', function() Snacks.picker.resume() end, { desc = 'Resume' })
vim.keymap.set('n', '<leader>ss', function() Snacks.picker.pickers() end, { desc = 'Snacks' })
vim.keymap.set('n', '<leader>se', function() Snacks.picker.files { hidden = true, ignored = true, title = 'Everything' } end, { desc = 'Everything' })
vim.keymap.set({ 'n', 'v' }, '<leader>st', open_toolbox, { desc = '[S]earch [T]oolbox' })
vim.keymap.set('n', '<leader>if', function() Snacks.picker.explorer { hidden = true, ignored = true } end, { desc = 'File tree' })
-- LSP pickers
vim.keymap.set('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = 'Goto Definition' })
vim.keymap.set('n', 'gD', function() Snacks.picker.lsp_declarations() end, { desc = 'Goto Declaration' })
vim.keymap.set('n', 'gr', function() Snacks.picker.lsp_references() end, { nowait = true, desc = 'References' })
vim.keymap.set('n', 'gI', function() Snacks.picker.lsp_implementations() end, { desc = 'Goto Implementation' })
vim.keymap.set('n', 'gy', function() Snacks.picker.lsp_type_definitions() end, { desc = 'Goto T[y]pe Definition' })
-- Bookmarks & file path
vim.keymap.set('n', ';', open_bookmarks, { desc = 'Bookmarks' })
vim.keymap.set('n', '<leader>a', paste_file_path, { desc = 'Paste file path' })
