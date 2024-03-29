vim.keymap.set('n', '<leader>set', ':tabnew $MYVIMRC<CR>', {desc = 'open MYVIMRC'})
-- Mappings
vim.keymap.set('n', '<c-s>', ':wa<cr>', {desc = 'Save file'})
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', {desc = 'Save to global clipboard'})
vim.keymap.set({'n', 'v'}, '<leader>p', '"+p', {desc = 'Past from global clipboard'})
--tabs
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', {desc = 'new tab'})
vim.keymap.set('n', '<leader>vs', ':vs<CR><c-w>w', {desc = 'open new split window and focus on it'})
vim.keymap.set('n', '<leader>tc', ':clo<CR>', {desc = 'close current tab'})
--something
vim.keymap.set('n', 'i', 'zzi', {desc = 'center screen when entering insert mode'})

vim.keymap.set('n', '<leader>fo', '<cmd>lua require("core.functions_fzf_lua").openFile()<CR>', {desc = 'find and open note through telescope'})
vim.keymap.set('n', '<leader>h', '<cmd>FzfLua oldfiles<CR>', {desc = 'open history pane'})
vim.keymap.set('n', '<leader>bl', '<cmd>lua require("fzf-lua").blines()<CR>', {desc = 'поиск по открытым buffers'})
--complition
vim.keymap.set('n', '<leader>sn', '<cmd>lua require("luasnip").jump(1)<CR>', {desc = 'next snippet placeholder'})
vim.keymap.set('n', '<leader>sp', '<cmd>lua require("luasnip").jump(-1)<CR>', {desc = 'previous snippet placeholder'})
--calendar/journal
vim.keymap.set('n', '<leader>jo', '<cmd>Calendar<CR>', {desc = 'open calendar'})
vim.keymap.set('n', '<leader>jt', '<cmd>lua require("core.custom_functions").openJournal()<CR>', {desc = 'open todays daily note'})
vim.keymap.set('n', '<leader>jn', '<cmd>lua require("core.custom_functions").openJournalShift(1)<CR>', {desc = 'open next daily note'})
vim.keymap.set('n', '<leader>jp', '<cmd>lua require("core.custom_functions").openJournalShift(-1)<CR>', {desc = 'open previous daily note'})
vim.keymap.set('n', '<leader>js', '<cmd>lua require("core.custom_functions").openJournalSameDay()<CR>', {desc = 'open journal note for the same date'})
vim.keymap.set('n', '<leader>jl', '<cmd>lua require("core.functions_fzf_lua").journalList()<CR>', {desc = 'open list of all journals'})
-- align_to_char(length, reverse, preview, marks)
-- align_to_string(is_pattern, reverse, preview, marks)
-- align(str, reverse, marks)
-- operator(fn, opts)
-- Where:
--      length: integer
--      reverse: boolean
--      preview: boolean
--      marks: table (e.g. {1, 0, 23, 15})
--      str: string (can be plaintext or Lua pattern if is_pattern is true)

local NS = { noremap = true, silent = true }

vim.keymap.set('x', 'aa', function() require'align'.align_to_char(1, true)             end, NS) -- Aligns to 1 character, looking left
vim.keymap.set('x', 'as', function() require'align'.align_to_char(2, true, true)       end, NS) -- Aligns to 2 characters, looking left and with previews
vim.keymap.set('x', 'aw', function() require'align'.align_to_string(false, true, true) end, NS) -- Aligns to a string, looking left and with previews
vim.keymap.set('x', 'ar', function() require'align'.align_to_string(true, true, true)  end, NS) -- Aligns to a Lua pattern, looking left and with previews
