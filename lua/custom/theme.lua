-- Inlined custom version of ayu-mirage colorscheme (replaces Shatur/neovim-ayu plugin)

local M = {}

-- Mirage color palette
local c = {
  white = '#FFFFFF',
  black = '#000000',
  lsp_inlay_hint = '#969696',
  accent = '#FFCC66',
  bg = '#1F2430',
  fg = '#CCCAC2',
  ui = '#707A8C',
  tag = '#5CCFE6',
  func = '#FFD173',
  entity = '#73D0FF',
  string = '#D5FF80',
  regexp = '#95E6CB',
  markup = '#F28779',
  keyword = '#FFAD66',
  special = '#FFDFB3',
  comment = '#6C7A8B',
  constant = '#DFBFFF',
  operator = '#F29E74',
  error = '#FF6666',
  lsp_parameter = '#D3B8F9',
  line = '#171B24',
  panel_bg = '#1C212B',
  panel_shadow = '#161922',
  panel_border = '#101521',
  gutter_normal = '#4A505A',
  gutter_active = '#757B84',
  selection_bg = '#274364',
  selection_inactive = '#23344B',
  selection_border = '#232A4C',
  guide_active = '#444A55',
  guide_normal = '#323843',
  vcs_added = '#87D96C',
  vcs_modified = '#80BFFF',
  vcs_removed = '#F27983',
  vcs_added_bg = '#313D37',
  vcs_removed_bg = '#3E373A',
  fg_idle = '#707A8C',
  warning = '#FFA759',
}

local function set_terminal_colors()
  vim.g.terminal_color_0 = c.bg
  vim.g.terminal_color_1 = c.markup
  vim.g.terminal_color_2 = c.string
  vim.g.terminal_color_3 = c.accent
  vim.g.terminal_color_4 = c.tag
  vim.g.terminal_color_5 = c.constant
  vim.g.terminal_color_6 = c.regexp
  vim.g.terminal_color_7 = c.fg
  vim.g.terminal_color_8 = c.fg_idle
  vim.g.terminal_color_9 = c.error
  vim.g.terminal_color_10 = c.string
  vim.g.terminal_color_11 = c.accent
  vim.g.terminal_color_12 = c.tag
  vim.g.terminal_color_13 = c.constant
  vim.g.terminal_color_14 = c.regexp
  vim.g.terminal_color_15 = c.comment
  vim.g.terminal_color_background = c.bg
  vim.g.terminal_color_foreground = c.fg
end

local function set_groups()
  local groups = {
    -- Base
    Normal = { fg = c.fg, bg = c.bg },
    NormalFloat = { bg = c.bg },
    FloatBorder = { fg = c.comment },
    FloatTitle = { fg = c.fg },
    ColorColumn = { bg = c.line },
    Cursor = { fg = c.bg, bg = c.fg },
    CursorColumn = { bg = c.line },
    CursorLine = { bg = c.line },
    CursorLineNr = { fg = c.accent, bg = c.line },
    LineNr = { fg = '#778899' }, -- override
    Directory = { fg = c.func },
    ErrorMsg = { fg = c.error },
    WinSeparator = { fg = c.panel_border, bg = c.bg },
    VertSplit = { link = 'WinSeparator' },
    Folded = { fg = '#6495ed' }, -- override
    FoldColumn = { fg = '#6495ed' }, -- override
    SignColumn = { bg = c.bg },
    MatchParen = { sp = c.func, underline = true },
    ModeMsg = { fg = c.string },
    MoreMsg = { fg = c.string },
    NonText = { fg = c.guide_normal },
    Pmenu = { fg = c.fg, bg = c.panel_bg },
    PmenuSel = { fg = c.fg, bg = c.selection_inactive, reverse = true },
    Question = { fg = c.string },
    Search = { fg = c.bg, bg = c.constant },
    CurSearch = { fg = c.bg, bg = c.special },
    IncSearch = { fg = c.keyword, bg = c.selection_inactive },
    SpecialKey = { fg = c.selection_inactive },
    SpellCap = { sp = c.tag, undercurl = true },
    SpellLocal = { sp = c.keyword, undercurl = true },
    SpellBad = { sp = c.error, undercurl = true },
    SpellRare = { sp = c.regexp, undercurl = true },
    StatusLine = { fg = c.fg, bg = c.panel_bg },
    StatusLineNC = { fg = c.fg_idle, bg = c.panel_bg },
    WildMenu = { fg = c.fg, bg = c.markup },
    TabLine = { fg = c.comment, bg = c.panel_shadow },
    TabLineFill = { fg = c.fg, bg = c.panel_border },
    TabLineSel = { fg = c.fg, bg = c.bg },
    Title = { fg = c.keyword },
    Visual = { bg = c.selection_inactive },
    WarningMsg = { fg = c.warning },

    -- Syntax
    Comment = { fg = '#b0c4de' }, -- override
    Constant = { fg = c.constant },
    String = { fg = c.string },
    Identifier = { fg = c.entity },
    Function = { fg = c.func },
    Statement = { fg = c.keyword },
    Operator = { fg = c.operator },
    Exception = { fg = c.markup },
    PreProc = { fg = c.accent },
    Type = { fg = c.entity },
    Structure = { fg = c.special },
    Special = { fg = c.accent },
    Delimiter = { fg = c.special },
    Underlined = { sp = c.tag, underline = true },
    Ignore = { fg = c.fg },
    Error = { fg = c.white, bg = c.error },
    Todo = { fg = c.markup },
    qfLineNr = { fg = c.keyword },
    qfError = { fg = c.error },
    Conceal = { fg = c.comment },
    CursorLineConceal = { fg = c.guide_normal, bg = c.line },

    -- VCS/Diff
    Added = { fg = c.vcs_added },
    Removed = { fg = c.vcs_removed },
    Changed = { fg = c.vcs_modified },
    DiffAdd = { bg = c.vcs_added_bg },
    DiffAdded = { fg = c.vcs_added },
    DiffDelete = { bg = c.vcs_removed_bg },
    DiffRemoved = { fg = c.vcs_removed },
    DiffText = { bg = c.gutter_normal },
    DiffChange = { bg = c.selection_inactive },

    -- LSP
    DiagnosticError = { fg = c.error },
    DiagnosticWarn = { fg = c.keyword },
    DiagnosticInfo = { fg = c.tag },
    DiagnosticHint = { fg = c.regexp },
    DiagnosticUnderlineError = { sp = c.error, undercurl = true },
    DiagnosticUnderlineWarn = { sp = c.keyword, undercurl = true },
    DiagnosticUnderlineInfo = { sp = c.tag, undercurl = true },
    DiagnosticUnderlineHint = { sp = c.regexp, undercurl = true },
    LspInlayHint = { fg = c.lsp_inlay_hint },
    LspSignatureActiveParameter = { italic = true },

    -- Markdown
    markdownCode = { fg = c.special },

    -- TreeSitter
    ['@property'] = { fg = c.entity }, -- TS override
    ['@tag'] = { fg = c.keyword },
    ['@tag.attribute'] = { fg = c.entity },
    ['@tag.delimiter'] = { link = 'Delimiter' },
    ['@type'] = { fg = c.entity }, -- TS override
    ['@type.builtin'] = { fg = c.entity }, -- TS override
    ['@type.qualifier'] = { fg = c.keyword },
    ['@constructor'] = { fg = c.entity }, -- TS override
    ['@variable'] = { fg = c.fg },
    ['@variable.builtin'] = { fg = c.func },
    ['@variable.member'] = { fg = c.entity }, -- TS override
    ['@variable.parameter'] = { fg = c.lsp_parameter }, -- TS override
    ['@module'] = { fg = c.func },
    ['@markup.heading'] = { fg = c.keyword },
    ['@keyword.storage'] = { fg = c.keyword },
    ['@constant'] = { fg = c.constant }, -- TS override
    ['@constant.builtin'] = { fg = c.constant }, -- TS override

    -- LSP semantic tokens
    ['@lsp.type.namespace'] = { link = '@module' },
    ['@lsp.type.type'] = { link = '@type' },
    ['@lsp.type.class'] = { link = '@type' },
    ['@lsp.type.enum'] = { link = '@type' },
    ['@lsp.type.interface'] = { link = '@type' },
    ['@lsp.type.struct'] = { link = '@variable.member' },
    ['@lsp.type.parameter'] = { fg = c.lsp_parameter },
    ['@lsp.type.field'] = { link = '@variable.member' },
    ['@lsp.type.variable'] = { link = '@variable' },
    ['@lsp.type.property'] = { link = '@property' },
    ['@lsp.type.enumMember'] = { link = '@constant' },
    ['@lsp.type.function'] = { link = '@function' },
    ['@lsp.type.method'] = { link = '@function.method' },
    ['@lsp.type.macro'] = { link = '@function.macro' },
    ['@lsp.type.decorator'] = { link = '@function' },
    ['@lsp.mod.constant'] = { link = '@constant' },

    -- TreesitterContext
    TreesitterContext = { bg = c.selection_inactive },

    -- Blink Cmp (tokyonight-style: link kinds to syntax groups)
    BlinkCmpDoc = { fg = c.fg, bg = c.panel_bg },
    BlinkCmpDocBorder = { fg = c.comment, bg = c.panel_bg },
    BlinkCmpGhostText = { fg = c.gutter_normal },
    BlinkCmpLabel = { fg = c.fg },
    BlinkCmpLabelDeprecated = { fg = c.gutter_normal, strikethrough = true },
    BlinkCmpLabelDescription = { fg = c.comment },
    BlinkCmpLabelDetail = { fg = c.comment },
    BlinkCmpLabelMatch = { fg = c.entity },
    BlinkCmpMenu = { fg = c.fg, bg = c.panel_bg },
    BlinkCmpMenuBorder = { fg = c.comment, bg = c.panel_bg },
    BlinkCmpMenuSelection = { bg = c.selection_inactive },
    BlinkCmpScrollBarGutter = { bg = c.line },
    BlinkCmpScrollBarThumb = { bg = c.fg_idle },
    BlinkCmpSignatureHelp = { fg = c.fg, bg = c.panel_bg },
    BlinkCmpSignatureHelpBorder = { fg = c.comment, bg = c.panel_bg },
    BlinkCmpKindDefault = { fg = c.fg_idle },
    BlinkCmpKindArray = { link = '@punctuation.bracket' },
    BlinkCmpKindBoolean = { link = '@boolean' },
    BlinkCmpKindClass = { link = '@type' },
    BlinkCmpKindColor = { link = 'Special' },
    BlinkCmpKindConstant = { link = '@constant' },
    BlinkCmpKindConstructor = { link = '@constructor' },
    BlinkCmpKindEnum = { link = '@lsp.type.enum' },
    BlinkCmpKindEnumMember = { link = '@lsp.type.enumMember' },
    BlinkCmpKindEvent = { link = 'Special' },
    BlinkCmpKindField = { link = '@variable.member' },
    BlinkCmpKindFile = { link = 'Normal' },
    BlinkCmpKindFolder = { link = 'Directory' },
    BlinkCmpKindFunction = { link = '@function' },
    BlinkCmpKindInterface = { link = '@lsp.type.interface' },
    BlinkCmpKindKey = { link = '@variable.member' },
    BlinkCmpKindKeyword = { link = '@lsp.type.keyword' },
    BlinkCmpKindMethod = { link = '@function.method' },
    BlinkCmpKindModule = { link = '@module' },
    BlinkCmpKindNamespace = { link = '@module' },
    BlinkCmpKindNull = { link = '@constant.builtin' },
    BlinkCmpKindNumber = { link = '@number' },
    BlinkCmpKindObject = { link = '@constant' },
    BlinkCmpKindOperator = { link = '@operator' },
    BlinkCmpKindPackage = { link = '@module' },
    BlinkCmpKindProperty = { link = '@property' },
    BlinkCmpKindReference = { link = '@markup.link' },
    BlinkCmpKindSnippet = { link = 'Conceal' },
    BlinkCmpKindString = { link = '@string' },
    BlinkCmpKindStruct = { link = '@lsp.type.struct' },
    BlinkCmpKindText = { link = '@markup' },
    BlinkCmpKindTypeParameter = { link = '@lsp.type.typeParameter' },
    BlinkCmpKindUnit = { link = '@lsp.type.struct' },
    BlinkCmpKindValue = { link = '@string' },
    BlinkCmpKindVariable = { link = '@variable' },

    -- Word under cursor
    CursorWord = { bg = c.selection_inactive },
    CursorWord0 = { bg = c.selection_inactive },
    CursorWord1 = { bg = c.selection_inactive },

    -- Flash
    FlashBackdrop = { fg = c.comment },
    FlashMatch = { fg = c.bg, bg = c.warning },
    FlashCurrent = { fg = c.bg, bg = c.tag },
    FlashLabel = { fg = c.white, bg = c.error, bold = true },
    FlashCursor = { reverse = true },

    -- Mini
    MiniFilesTitleFocused = { fg = c.fg, bold = true },
    MiniHipatternsFixme = { fg = c.bg, bg = c.error, bold = true },
    MiniHipatternsHack = { fg = c.bg, bg = c.keyword, bold = true },
    MiniHipatternsTodo = { fg = c.bg, bg = c.tag, bold = true },
    MiniHipatternsNote = { fg = c.bg, bg = c.regexp, bold = true },
    MiniIconsAzure = { fg = c.tag },
    MiniIconsBlue = { fg = c.entity },
    MiniIconsCyan = { fg = c.regexp },
    MiniIconsGreen = { fg = c.string },
    MiniIconsGrey = { fg = c.fg },
    MiniIconsOrange = { fg = c.keyword },
    MiniIconsPurple = { fg = c.lsp_parameter },
    MiniIconsRed = { fg = c.error },
    MiniIconsYellow = { fg = c.special },
    MiniIndentscopeSymbol = { fg = c.comment },
    MiniIndentscopeSymbolOff = { fg = c.keyword },

    -- Render Markdown
    RenderMarkdownH1 = { fg = c.vcs_added },
    RenderMarkdownH2 = { fg = c.string },
    RenderMarkdownH3 = { fg = c.accent },
    RenderMarkdownH4 = { fg = c.keyword },
    RenderMarkdownH5 = { fg = c.markup },
    RenderMarkdownH6 = { fg = c.constant },
    RenderMarkdownH1Bg = { bg = c.line, fg = c.vcs_added },
    RenderMarkdownH2Bg = { bg = c.line, fg = c.string },
    RenderMarkdownH3Bg = { bg = c.line, fg = c.accent },
    RenderMarkdownH4Bg = { bg = c.line, fg = c.keyword },
    RenderMarkdownH5Bg = { bg = c.line, fg = c.markup },
    RenderMarkdownH6Bg = { bg = c.line, fg = c.constant },
    RenderMarkdownQuote = { fg = c.accent },
    RenderMarkdownQuote1 = { fg = c.accent },
    RenderMarkdownQuote2 = { fg = c.keyword },
    RenderMarkdownQuote3 = { fg = c.markup },
    RenderMarkdownQuote4 = { fg = c.constant },
    RenderMarkdownQuote5 = { fg = c.constant },
    RenderMarkdownQuote6 = { fg = c.constant },
    RenderMarkdownBullet = { fg = c.vcs_added },
    RenderMarkdownDash = { fg = c.accent },
    RenderMarkdownSign = { fg = c.accent },
    RenderMarkdownMath = { fg = c.accent },
    RenderMarkdownIndent = { fg = c.accent },
    RenderMarkdownHtmlComment = { fg = c.comment },
    RenderMarkdownLink = { fg = c.tag },
    RenderMarkdownWikiLink = { fg = c.tag },
    RenderMarkdownUnchecked = { fg = c.markup },
    RenderMarkdownChecked = { fg = c.vcs_added },
    RenderMarkdownTodo = { fg = c.vcs_added },
    RenderMarkdownTableHead = { fg = c.comment },
    RenderMarkdownTableRow = { fg = c.comment },
    RenderMarkdownTableFill = { fg = c.comment },

    -- HTML
    htmlTag = { fg = c.entity },
    htmlEndTag = { link = 'htmlTag' },
    htmlTagName = { fg = c.entity },
    htmlArg = { fg = c.func },
    htmlTitle = { bold = true, fg = c.fg },
    htmlH1 = { link = 'htmlTitle' },
    htmlH2 = { link = 'htmlTitle' },
    htmlH3 = { link = 'htmlTitle' },
    htmlH4 = { link = 'htmlTitle' },
    htmlH5 = { link = 'htmlTitle' },
    htmlH6 = { link = 'htmlTitle' },

    -- Gitsigns
    GitSignsCurrentLineBlame = { fg = c.gutter_normal, italic = true },

    -- Snacks
    SnacksPickerDir = { link = 'Comment' },
    SnacksPickerPathHidden = { link = 'Comment' },
    SnacksPickerPathIgnored = { link = 'Comment' },
    SnacksPickerGitStatusUntracked = { link = 'Special' },
  }

  for group, parameters in pairs(groups) do
    vim.api.nvim_set_hl(0, group, parameters)
  end
end

function M.setup()
  vim.api.nvim_command 'hi clear'
  if vim.fn.exists 'syntax_on' then vim.api.nvim_command 'syntax reset' end

  vim.g.VM_theme_set_by_colorscheme = true
  vim.o.termguicolors = true
  vim.o.background = 'dark'

  set_terminal_colors()
  set_groups()
end

return M
