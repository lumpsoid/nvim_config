-- ~/.config/nvim/colors/flat-white-l.lua

vim.cmd('highlight clear')
if vim.fn.exists('syntax_on') then
  vim.cmd('syntax reset')
end

vim.g.colors_name = 'flat-white-l'

-- Base colors
local colors = {
  bg = '#ffffff',           -- Pure white background
  fg = '#2a2a2a',           -- Main text (dark gray for readability)
  
  -- Much more distinct warm background colors
  bg_keyword = '#ffcc80',   -- Orange - for keywords
  bg_string = '#c8e6c9',    -- Green - for strings
  bg_comment = '#e0e0e0',   -- Gray - for comments
  bg_function = '#d1c4e9',  -- Purple - for functions
  bg_type = '#f8bbd9',      -- Pink - for types
  bg_constant = '#b3e5fc',  -- Blue - for constants
  bg_variable = '#ffccbc',  -- Light coral - for variables
  bg_operator = '#dcedc8',  -- Light green - for operators
  bg_parameter = '#ffe0cc', -- Light orange - for parameters
  bg_call_parameter = '#b2dfdb',  -- Light teal - for function call parameters
  bg_label = '#fce4ec',     -- Light rose - for labels
  
  -- UI elements
  bg_cursor = '#f0f0f0',    -- Cursor line
  bg_visual = '#b3d9ff',    -- Visual selection
  bg_search = '#ffeb3b',    -- Search results
  bg_incsearch = '#ff9800', -- Incremental search
  
  -- Diagnostics
  bg_error = '#ffcdd2',     -- Error background
  bg_warning = '#fff9c4',   -- Warning background
  bg_info = '#e1f5fe',      -- Info background
  bg_hint = '#f3e5f5',      -- Hint background
  
  -- Git diff
  bg_add = '#c8e6c9',       -- Added lines
  bg_change = '#ffe0b2',    -- Modified lines
  bg_delete = '#ffcdd2',    -- Deleted lines
  
  -- Borders and UI
  border = '#cccccc',
  bg_float = '#f8f8f8',
}

local highlights = {
  -- Base groups - NO background highlighting for normal text
  Normal = { fg = colors.fg, bg = colors.bg },
  NormalFloat = { fg = colors.fg, bg = colors.bg_float },
  FloatBorder = { fg = colors.border, bg = colors.bg_float },
  
  -- Cursor and selection
  CursorLine = { bg = colors.bg_cursor },
  CursorColumn = { bg = colors.bg_cursor },
  Visual = { bg = colors.bg_visual },
  VisualNOS = { bg = colors.bg_visual },
  
  -- Search
  Search = { fg = colors.fg, bg = colors.bg_search },
  IncSearch = { fg = colors.fg, bg = colors.bg_incsearch },
  CurSearch = { fg = colors.fg, bg = colors.bg_incsearch },
  
  -- Line numbers and signs
  LineNr = { fg = '#999999', bg = colors.bg },
  CursorLineNr = { fg = colors.fg, bg = colors.bg_cursor, bold = true },
  SignColumn = { fg = colors.fg, bg = colors.bg },
  
  -- DEFAULT SYMBOLS - no background, just normal text
  Whitespace = { fg = colors.fg },
  NonText = { fg = colors.fg },
  SpecialKey = { fg = colors.fg },
  
  -- PUNCTUATION - no background highlighting
  Delimiter = { fg = colors.fg },  -- Brackets, parentheses, etc.
  Operator = { fg = colors.fg },   -- +, -, *, /, etc.
  Punctuation = { fg = colors.fg }, -- General punctuation
  
  -- Syntax highlighting with DISTINCT background colors
  Comment = { fg = colors.fg, bg = colors.bg_comment, italic = true },
  
  -- Keywords - bright orange background
  Keyword = { fg = colors.fg, bg = colors.bg_keyword, bold = true },
  Conditional = { fg = colors.fg, bg = colors.bg_keyword, bold = true },
  Repeat = { fg = colors.fg, bg = colors.bg_keyword, bold = true },
  Statement = { fg = colors.fg, bg = colors.bg_keyword, bold = true },
  
  -- Strings - green background
  String = { fg = colors.fg, bg = colors.bg_string },
  Character = { fg = colors.fg, bg = colors.bg_string },
  
  -- Functions - purple background
  Function = { fg = colors.fg, bg = colors.bg_function },
  
  -- Types - pink background
  Type = { fg = colors.fg, bg = colors.bg_type },
  StorageClass = { fg = colors.fg, bg = colors.bg_type },
  Structure = { fg = colors.fg, bg = colors.bg_type },
  
  -- Constants - blue background
  Constant = { fg = colors.fg, bg = colors.bg_constant },
  Number = { fg = colors.fg, bg = colors.bg_constant },
  Boolean = { fg = colors.fg, bg = colors.bg_constant },
  Float = { fg = colors.fg, bg = colors.bg_constant },
  
  -- Variables - light coral background
  Variable = { fg = colors.fg, bg = colors.bg_variable },
  Identifier = { fg = colors.fg, bg = colors.bg_variable },
  
  -- TreeSitter variable highlighting
  ['@variable'] = { fg = colors.fg, bg = colors.bg_variable },
  ['@variable.lua'] = { fg = colors.fg, bg = colors.bg_variable },
  ['@variable.dart'] = { fg = colors.fg, bg = colors.bg_variable },
  
  -- LSP semantic token highlighting for variables
  ['@lsp.type.variable.lua'] = { fg = colors.fg, bg = colors.bg_variable },
  ['@lsp.mod.declaration.lua'] = { fg = colors.fg, bg = colors.bg_variable },
  ['@lsp.typemod.variable.declaration.lua'] = { fg = colors.fg, bg = colors.bg_variable },
  
  -- Parameters - light orange background
  Parameter = { fg = colors.fg, bg = colors.bg_parameter },
  
  -- Function call parameters - light teal background
  ['@variable.parameter'] = { fg = colors.fg, bg = colors.bg_call_parameter },
  ['@variable.parameter.dart'] = { fg = colors.fg, bg = colors.bg_call_parameter },
  ['@lsp.type.parameter'] = { fg = colors.fg, bg = colors.bg_call_parameter },
  ['@lsp.type.parameter.dart'] = { fg = colors.fg, bg = colors.bg_call_parameter },
  ['@lsp.typemod.parameter.label.dart'] = { fg = colors.fg, bg = colors.bg_call_parameter },
  
  -- Labels - light rose background
  ['@lsp.mod.label'] = { fg = colors.fg, bg = colors.bg_label },
  ['@lsp.mod.label.dart'] = { fg = colors.fg, bg = colors.bg_label },
  
  -- Generic LSP fallback
  ['@lsp'] = { fg = colors.fg },
  
  -- TreeSitter field/property highlighting
  ['@field'] = { fg = colors.fg, bg = colors.bg_variable },
  ['@property'] = { fg = colors.fg, bg = colors.bg_variable },
  ['@variable.member'] = { fg = colors.fg, bg = colors.bg_variable },
  
  -- Preprocessor - same as keywords (orange)
  PreProc = { fg = colors.fg, bg = colors.bg_keyword, bold = true },
  Include = { fg = colors.fg, bg = colors.bg_keyword, bold = true },
  Define = { fg = colors.fg, bg = colors.bg_keyword, bold = true },
  Macro = { fg = colors.fg, bg = colors.bg_keyword, bold = true },
  
  -- Special - NO background for special characters
  Special = { fg = colors.fg },
  SpecialChar = { fg = colors.fg },
  SpecialComment = { fg = colors.fg, bg = colors.bg_comment, bold = true },
  
  -- Matching brackets - keep highlighted
  MatchParen = { fg = colors.fg, bg = colors.bg_incsearch, bold = true },
  
  -- LSP semantic tokens for parameters (function definitions)
  ['@lsp.type.parameter'] = { fg = colors.fg, bg = colors.bg_parameter },
  ['@lsp.type.parameter.python'] = { fg = colors.fg, bg = colors.bg_parameter },
  ['@lsp.type.parameter.javascript'] = { fg = colors.fg, bg = colors.bg_parameter },
  ['@lsp.type.parameter.typescript'] = { fg = colors.fg, bg = colors.bg_parameter },
  
  -- Diff
  DiffAdd = { fg = colors.fg, bg = colors.bg_add },
  DiffChange = { fg = colors.fg, bg = colors.bg_change },
  DiffDelete = { fg = colors.fg, bg = colors.bg_delete },
  DiffText = { fg = colors.fg, bg = colors.bg_change, bold = true },
  
  -- Git signs
  GitSignsAdd = { fg = colors.fg, bg = colors.bg_add },
  GitSignsChange = { fg = colors.fg, bg = colors.bg_change },
  GitSignsDelete = { fg = colors.fg, bg = colors.bg_delete },
  
  -- LSP Diagnostics
  DiagnosticError = { fg = colors.fg, bg = colors.bg_error, underline = true },
  DiagnosticWarn = { fg = colors.fg, bg = colors.bg_warning, underline = true },
  DiagnosticInfo = { fg = colors.fg, bg = colors.bg_info, underline = true },
  DiagnosticHint = { fg = colors.fg, bg = colors.bg_hint, underline = true },
  
  -- LSP Diagnostic signs
  DiagnosticSignError = { fg = colors.fg, bg = colors.bg_error },
  DiagnosticSignWarn = { fg = colors.fg, bg = colors.bg_warning },
  DiagnosticSignInfo = { fg = colors.fg, bg = colors.bg_info },
  DiagnosticSignHint = { fg = colors.fg, bg = colors.bg_hint },
  
  -- UI elements
  Pmenu = { fg = colors.fg, bg = colors.bg_float },
  PmenuSel = { fg = colors.fg, bg = colors.bg_visual },
  PmenuSbar = { bg = colors.border },
  PmenuThumb = { bg = colors.fg },
  
  -- Status line
  StatusLine = { fg = colors.fg, bg = colors.bg_cursor },
  StatusLineNC = { fg = '#999999', bg = colors.bg_cursor },
  
  -- Tabs
  TabLine = { fg = colors.fg, bg = colors.bg_cursor },
  TabLineFill = { fg = colors.fg, bg = colors.bg_cursor },
  TabLineSel = { fg = colors.fg, bg = colors.bg_visual },
  
  -- Folds
  Folded = { fg = colors.fg, bg = colors.bg_comment },
  FoldColumn = { fg = colors.fg, bg = colors.bg },
  
  -- Misc
  Todo = { fg = colors.fg, bg = colors.bg_warning, bold = true },
  Error = { fg = colors.fg, bg = colors.bg_error, bold = true },
  ErrorMsg = { fg = colors.fg, bg = colors.bg_error, bold = true },
  WarningMsg = { fg = colors.fg, bg = colors.bg_warning, bold = true },
  
  -- Spell checking
  SpellBad = { fg = colors.fg, bg = colors.bg_error, undercurl = true },
  SpellCap = { fg = colors.fg, bg = colors.bg_warning, undercurl = true },
  SpellLocal = { fg = colors.fg, bg = colors.bg_info, undercurl = true },
  SpellRare = { fg = colors.fg, bg = colors.bg_hint, undercurl = true },
}

-- Apply highlights
for group, opts in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, opts)
end
