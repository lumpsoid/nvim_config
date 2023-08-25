require('hop').setup({ 
--    keys = 'asdfghjkl',
    quit_key = '<ESC>',
    jump_on_sole_occurrence = false,
    smartcase = true,
    uppercase_labels = false,
})

-- keymaps
vim.keymap.set('n', ',w', ':HopWordMW<CR>', {desc = 'All words in visible buffers'})
vim.keymap.set('n', ',j', ':HopLineMW<CR>', {desc = 'two way line'})
vim.keymap.set('n', ',p', ':HopPatternMW<CR>', {desc = 'Pattern in all visible buffers'})
vim.keymap.set(
                'n', 
                '<TAB>', 
                [[:lua require("core.hop-custom").hint_wikilink_follow("\\[\\[")<CR>]], 
                {desc = 'Find all notes [[timestamp]]'}
)
--keys = 'etovxqpdygfblzhckisuran'
