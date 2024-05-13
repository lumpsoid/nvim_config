-- unmaintained 'phaazon/hop.nvim',
return {
  'smoka7/hop.nvim',
  version = '*',
  opts = {
  --    keys = 'asdfghjkl',
      quit_key = '<ESC>',
      jump_on_sole_occurrence = false,
      smartcase = true,
      uppercase_labels = false,
    },
  config = function()
    require('hop').setup()
    -- keymaps
    vim.keymap.set('n', ',w', ':HopWordMW<CR>', {desc = 'All words in visible buffers'})
    vim.keymap.set('n', ',j', ':HopLineMW<CR>', {desc = 'two way line'})
    vim.keymap.set('n', ',p', ':HopPatternMW<CR>', {desc = 'Pattern in all visible buffers'})
    vim.keymap.set(
      'n',
      'gl',
      [[:lua require("core.hop-custom").hint_wikilink_follow("\\[\\[")<CR>]],
      {desc = 'Find all notes [[timestamp]]'}
    )
  end
}
