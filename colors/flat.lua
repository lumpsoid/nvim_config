-- colors/flat.lua
-- Converted from Zed's Flat Theme by blaqat

local M = {}

-- Helper function to set highlights
local function highlight(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Theme setup function
function M.setup()
  -- Clear existing highlights
  vim.cmd('highlight clear')
  if vim.fn.exists('syntax_on') then
    vim.cmd('syntax reset')
  end

  -- Set colorscheme name
  vim.g.colors_name = 'flat'

  -- Detect background
  local is_dark = vim.o.background == 'dark'

  -- Color palette based on theme variant
  local colors = {}
  
  if is_dark then
    -- Dark theme colors
    colors = {
      bg = '#24374b',
      fg = '#f1ece4',
      bg_alt = '#1b2838',
      fg_alt = '#e0e2ea',
      bg_select = '#344b5e',
      bg_line = '#344b5e',
      comment = '#6094bb',
      accent = '#C0B6F2',
      
      -- Syntax background colors (main feature)
      keyword_bg = '#3d2f1a',      -- darker version of #f1c897
      string_bg = '#2d3020',       -- darker version of #d0dc9b
      number_bg = '#1f2f28',       -- darker version of #afdbcd
      boolean_bg = '#1f2f28',      -- darker version of #afdbcd
      constant_bg = '#1f2f28',     -- darker version of #afdbcd
      type_bg = '#2e1f2e',         -- darker version of #e2b9e2
      tag_bg = '#1f2635',          -- darker version of #b8c7e4
      attribute_bg = '#3d2f1a',    -- darker version of #f1c897
      text_bg = '#3d2f1a',         -- darker version of #f1c897
      method_bg = '#1f2635',       -- similar to tag_bg for methods
      function_bg = '#1f2635',     -- similar to tag_bg for functions
      
      -- Syntax foreground colors
      keyword_fg = '#f1c897',
      string_fg = '#d0dc9b',
      number_fg = '#afdbcd',
      boolean_fg = '#afdbcd',
      constant_fg = '#afdbcd',
      type_fg = '#e2b9e2',
      tag_fg = '#b8c7e4',
      attribute_fg = '#f1c897',
      operator_fg = '#e0e2ea',
      punctuation_fg = '#e0e2ea',
      method_fg = '#b8c7e4',
      function_fg = '#b8c7e4',
      
      -- Status colors
      error = '#F27988',
      warning = '#ecbe70',
      info = '#62BEF5',
      hint = '#6D8194',
      success = '#99E672',
      
      -- Git colors
      added = '#5AB46C',
      modified = '#F2C261',
      deleted = '#FF6667',
      
      -- UI colors
      line_number = '#b9a992',
      cursor_line_nr = '#f1ece4',
      search_bg = '#fce094',
      visual_bg = '#97CAF5',
      tab_active = '#24374b',
      tab_inactive = '#1b2838',
      tab_bar = '#131d29',
    }
  else
    -- Light theme colors
    colors = {
      bg = '#f7f3ee',
      fg = '#605a52',
      bg_alt = '#f1ece4',
      fg_alt = '#14161b',
      bg_select = '#e4ddd2',
      bg_line = '#f1ece4',
      comment = '#b9a992',
      accent = '#7766CC',
      
      -- Syntax background colors (main feature)
      keyword_bg = '#f7e0c3',      -- from original theme
      string_bg = '#e2e9c1',       -- from original theme
      number_bg = '#d2ebe3',       -- from original theme
      boolean_bg = '#d2ebe3',      -- from original theme
      constant_bg = '#d2ebe3',     -- from original theme
      type_bg = '#f1ddf1',         -- from original theme
      tag_bg = '#dde4f2',          -- from original theme
      attribute_bg = '#f7e0c3',    -- from original theme
      text_bg = '#f7e0c3',         -- from original theme
      method_bg = '#dde4f2',       -- same as tag_bg for methods
      function_bg = '#dde4f2',     -- same as tag_bg for functions
      
      -- Syntax foreground colors
      keyword_fg = '#5b5143',
      string_fg = '#525643',
      number_fg = '#465953',
      boolean_fg = '#465953',
      constant_fg = '#465953',
      type_fg = '#614c61',
      tag_fg = '#4c5361',
      attribute_fg = '#5b5143',
      operator_fg = '#605a52',
      punctuation_fg = '#605a52',
      method_fg = '#4c5361',
      function_fg = '#4c5361',
      
      -- Status colors
      error = '#CC3D4E',
      warning = '#ecbe70',
      info = '#247DB3',
      hint = '#93836c',
      success = '#77B359',
      
      -- Git colors
      added = '#4D995C',
      modified = '#CCA351',
      deleted = '#ff1414',
      
      -- UI colors
      line_number = '#b9a992',
      cursor_line_nr = '#605a52',
      search_bg = '#e4ddd2',
      visual_bg = '#e4ddd2',
      tab_active = '#f7f3ee',
      tab_inactive = '#ede8e0',
      tab_bar = '#D4CFC9',
    }
  end

  -- Editor highlights
  highlight('Normal', { fg = colors.fg, bg = colors.bg })
  highlight('NormalFloat', { fg = colors.fg, bg = colors.bg_alt })
  highlight('NormalNC', { fg = colors.fg, bg = colors.bg })
  
  -- Cursor and selection
  highlight('Cursor', { fg = colors.bg, bg = colors.fg })
  highlight('CursorLine', { bg = colors.bg_line })
  highlight('CursorColumn', { bg = colors.bg_line })
  highlight('Visual', { bg = colors.visual_bg })
  highlight('VisualNOS', { bg = colors.visual_bg })
  
  -- Line numbers
  highlight('LineNr', { fg = colors.line_number })
  highlight('CursorLineNr', { fg = colors.cursor_line_nr })
  highlight('SignColumn', { fg = colors.line_number, bg = colors.bg_alt })
  
  -- Folds
  highlight('Folded', { fg = colors.comment, bg = colors.bg_alt })
  highlight('FoldColumn', { fg = colors.comment, bg = colors.bg_alt })
  
  -- Search
  highlight('Search', { bg = colors.search_bg })
  highlight('IncSearch', { bg = colors.search_bg })
  highlight('CurSearch', { bg = colors.search_bg })
  
  -- Messages
  highlight('ErrorMsg', { fg = colors.error })
  highlight('WarningMsg', { fg = colors.warning })
  highlight('ModeMsg', { fg = colors.info })
  highlight('MoreMsg', { fg = colors.success })
  
  -- Statusline
  highlight('StatusLine', { fg = colors.fg, bg = colors.bg_alt })
  highlight('StatusLineNC', { fg = colors.comment, bg = colors.bg_alt })
  
  -- Tabline
  highlight('TabLine', { fg = colors.fg, bg = colors.tab_inactive })
  highlight('TabLineFill', { bg = colors.tab_bar })
  highlight('TabLineSel', { fg = colors.fg, bg = colors.tab_active })
  
  -- Popup menu
  highlight('Pmenu', { fg = colors.fg, bg = colors.bg_alt })
  highlight('PmenuSel', { fg = colors.fg, bg = colors.bg_select })
  highlight('PmenuSbar', { bg = colors.bg_alt })
  highlight('PmenuThumb', { bg = colors.comment })
  
  -- Syntax highlighting with background colors (main feature)
  highlight('Comment', { fg = colors.comment, italic = true })
  highlight('Constant', { fg = colors.constant_fg, bg = colors.constant_bg })
  highlight('String', { fg = colors.string_fg, bg = colors.string_bg })
  highlight('Character', { fg = colors.string_fg, bg = colors.string_bg })
  highlight('Number', { fg = colors.number_fg, bg = colors.number_bg })
  highlight('Boolean', { fg = colors.boolean_fg, bg = colors.boolean_bg })
  highlight('Float', { fg = colors.number_fg, bg = colors.number_bg })
  
  highlight('Identifier', { fg = colors.fg_alt })
  highlight('Function', { fg = colors.function_fg, bg = colors.function_bg })
  
  highlight('Statement', { fg = colors.keyword_fg, bg = colors.keyword_bg })
  highlight('Conditional', { fg = colors.keyword_fg, bg = colors.keyword_bg })
  highlight('Repeat', { fg = colors.keyword_fg, bg = colors.keyword_bg })
  highlight('Label', { fg = colors.keyword_fg, bg = colors.keyword_bg })
  highlight('Operator', { fg = colors.operator_fg })
  highlight('Keyword', { fg = colors.keyword_fg, bg = colors.keyword_bg })
  highlight('Exception', { fg = colors.keyword_fg, bg = colors.keyword_bg })
  
  highlight('PreProc', { fg = colors.keyword_fg, bg = colors.keyword_bg })
  highlight('Include', { fg = colors.keyword_fg, bg = colors.keyword_bg })
  highlight('Define', { fg = colors.keyword_fg, bg = colors.keyword_bg })
  highlight('Macro', { fg = colors.keyword_fg, bg = colors.keyword_bg })
  highlight('PreCondit', { fg = colors.keyword_fg, bg = colors.keyword_bg })
  
  highlight('Type', { fg = colors.type_fg, bg = colors.type_bg })
  highlight('StorageClass', { fg = colors.type_fg, bg = colors.type_bg })
  highlight('Structure', { fg = colors.type_fg, bg = colors.type_bg })
  highlight('Typedef', { fg = colors.type_fg, bg = colors.type_bg })
  
  highlight('Special', { fg = colors.accent })
  highlight('SpecialChar', { fg = colors.accent })
  highlight('Tag', { fg = colors.tag_fg, bg = colors.tag_bg })
  highlight('Delimiter', { fg = colors.punctuation_fg })
  highlight('SpecialComment', { fg = colors.comment })
  highlight('Debug', { fg = colors.accent })
  
  -- Diff
  highlight('DiffAdd', { fg = colors.added })
  highlight('DiffChange', { fg = colors.modified })
  highlight('DiffDelete', { fg = colors.deleted })
  highlight('DiffText', { fg = colors.modified })
  
  -- Git signs
  highlight('GitSignsAdd', { fg = colors.added })
  highlight('GitSignsChange', { fg = colors.modified })
  highlight('GitSignsDelete', { fg = colors.deleted })
  
  -- Diagnostics
  highlight('DiagnosticError', { fg = colors.error })
  highlight('DiagnosticWarn', { fg = colors.warning })
  highlight('DiagnosticInfo', { fg = colors.info })
  highlight('DiagnosticHint', { fg = colors.hint })
  
  -- LSP
  highlight('LspReferenceText', { bg = colors.bg_select })
  highlight('LspReferenceRead', { bg = colors.bg_select })
  highlight('LspReferenceWrite', { bg = colors.bg_select })
  
  -- LSP Semantic Token Types
  highlight('@lsp.type.method', { fg = colors.method_fg, bg = colors.method_bg })
  highlight('@lsp.type.function', { fg = colors.function_fg, bg = colors.function_bg })
  highlight('@lsp.type.class', { fg = colors.type_fg, bg = colors.type_bg })
  highlight('@lsp.type.struct', { fg = colors.type_fg, bg = colors.type_bg })
  highlight('@lsp.type.interface', { fg = colors.type_fg, bg = colors.type_bg })
  highlight('@lsp.type.enum', { fg = colors.type_fg, bg = colors.type_bg })
  highlight('@lsp.type.type', { fg = colors.type_fg, bg = colors.type_bg })
  highlight('@lsp.type.parameter', { fg = colors.fg_alt })
  highlight('@lsp.type.variable', { fg = colors.fg_alt })
  highlight('@lsp.type.property', { fg = colors.fg_alt })
  highlight('@lsp.type.enumMember', { fg = colors.constant_fg, bg = colors.constant_bg })
  highlight('@lsp.type.keyword', { fg = colors.keyword_fg, bg = colors.keyword_bg })
  highlight('@lsp.type.string', { fg = colors.string_fg, bg = colors.string_bg })
  highlight('@lsp.type.number', { fg = colors.number_fg, bg = colors.number_bg })
  highlight('@lsp.type.comment', { fg = colors.comment, italic = true })
  highlight('@lsp.type.namespace', { fg = colors.type_fg, bg = colors.type_bg })
  highlight('@lsp.type.macro', { fg = colors.keyword_fg, bg = colors.keyword_bg })
  
  -- LSP Semantic Token Modifiers
  highlight('@lsp.mod.static', { fg = colors.constant_fg, bg = colors.constant_bg })
  highlight('@lsp.mod.readonly', { fg = colors.constant_fg, bg = colors.constant_bg })
  highlight('@lsp.mod.deprecated', { fg = colors.comment, strikethrough = true })
  
  -- Treesitter with background highlights
  highlight('@comment', { link = 'Comment' })
  highlight('@constant', { link = 'Constant' })
  highlight('@string', { link = 'String' })
  highlight('@number', { link = 'Number' })
  highlight('@boolean', { link = 'Boolean' })
  highlight('@keyword', { link = 'Keyword' })
  highlight('@type', { link = 'Type' })
  highlight('@function', { link = 'Function' })
  highlight('@variable', { fg = colors.fg_alt })
  highlight('@property', { fg = colors.fg_alt })
  highlight('@tag', { link = 'Tag' })
  highlight('@attribute', { fg = colors.attribute_fg, bg = colors.attribute_bg, italic = true })
  highlight('@operator', { fg = colors.operator_fg })
  highlight('@punctuation', { fg = colors.punctuation_fg })
  highlight('@punctuation.bracket', { fg = colors.punctuation_fg })
  highlight('@punctuation.delimiter', { fg = colors.punctuation_fg })
  
  -- Function and method variations
  highlight('@function.method', { fg = colors.method_fg, bg = colors.method_bg })
  highlight('@function.builtin', { fg = colors.function_fg, bg = colors.function_bg })
  highlight('@function.call', { fg = colors.function_fg, bg = colors.function_bg })
  highlight('@method', { fg = colors.method_fg, bg = colors.method_bg })
  highlight('@method.call', { fg = colors.method_fg, bg = colors.method_bg })
  
  -- Specific language support
  highlight('@variable.special', { fg = colors.constant_fg, bg = colors.constant_bg, italic = true })
  highlight('@constant.builtin', { link = 'Constant' })
  highlight('@type.builtin', { link = 'Type' })
  highlight('@string.escape', { link = 'String' })
  highlight('@string.regex', { link = 'String' })
  
  -- Markdown
  highlight('@markup.heading', { fg = colors.attribute_fg, bg = colors.text_bg })
  highlight('@markup.link.url', { fg = colors.accent })
  highlight('@markup.link.label', { fg = colors.accent })
  
  -- Text elements
  highlight('@text', { fg = colors.attribute_fg, bg = colors.text_bg })
  highlight('@text.literal', { fg = colors.attribute_fg, bg = colors.text_bg })
  
  -- Borders and separators
  highlight('WinSeparator', { fg = colors.comment })
  highlight('VertSplit', { fg = colors.comment })
  highlight('FloatBorder', { fg = colors.comment })
  
  -- Misc
  highlight('Title', { fg = colors.attribute_fg, bg = colors.text_bg })
  highlight('Directory', { fg = colors.info })
  highlight('Underlined', { fg = colors.accent, underline = true })
  highlight('Bold', { bold = true })
  highlight('Italic', { italic = true })
  highlight('Question', { fg = colors.success })
  highlight('MatchParen', { bg = colors.bg_select })
  highlight('NonText', { fg = colors.comment })
  highlight('SpecialKey', { fg = colors.comment })
  highlight('Whitespace', { fg = colors.comment })
end

-- Auto-setup based on background
M.setup()

return M
