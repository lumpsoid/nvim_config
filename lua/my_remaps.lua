-- Mappings
--vim.keymap.set('n', '<c-s>', ':w<cr>', {desc = 'Save file'})
vim.keymap.set({'n', 'v'}, '<Leader>y', '"+y', {desc = 'Save to global clipboard'})
vim.keymap.set('n', '<Leader>p', '"+p', {desc = 'Past from global clipboard'})
--vim.keymap.set('n', '<leader>no', ':lua require("telescope.builtin").grep_string({ shorten_path = true, word_match = "-w", only_sort_text = true, search = "" })<CR>', {desc = 'open note'})
vim.keymap.set('n', '<leader>no', ':lua require("fzf-lua").grep()<CR>', {desc = 'find and open note through telescope'})
--vim.keymap.set('n', '<leader>zn', ':ZettelNew<space>', {desc = 'new note'})
--vim.keymap.set({'i', 'n'}, '<C-k>', '<esc>:lua require("custom_telescope").insertId()<CR>', {desc = 'for any note [[ID]] insert'})
vim.keymap.set({'i', 'n'}, '<C-k>', '<esc>:lua require("custom_fzf_lua").insertId()<CR>', {desc = 'for any note [[ID]] insert'})
--vim.keymap.set({'i', 'n'}, '<C-q>', '<esc>:lua require("custom_telescope").insertLink()<CR>', {desc = 'tree note [[ID]] insert'})
vim.keymap.set({'i', 'n'}, '<C-q>', '<esc>:lua require("custom_fzf_lua").insertHeadId()<CR>', {desc = 'tree note [[ID]] insert'})
vim.keymap.set('n', '<leader>nb', '<esc>:lua require("custom_telescope").backlinksSearch()<cr>', {desc = 'find backlinks to open note'})
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', {desc = 'new tab'})
vim.keymap.set('n', '<leader>vs', ':vs<CR><c-w>w', {desc = 'open new split window and focus on it'})
vim.keymap.set('n', '<leader>tc', ':clo<CR>', {desc = 'close current tab'})
vim.keymap.set('n', '<leader>h', ':Telescope oldfiles<CR>', {desc = 'open history pane'})
vim.keymap.set('n', 'sl', ':Lines<CR>', {desc = 'поиск по открытым buffers'})
vim.keymap.set('i', '<c-y>', '<esc>:lua require("custom_functions").createID()<cr>jjA', {desc = 'create new zettel file'})
vim.keymap.set('n', '<leader>na', '<esc>:lua require("custom_telescope").findAroundNote()<cr>', {desc = 'view notes which was created in the same date as current note'})
vim.keymap.set('n', 'i', 'zzi', {desc = 'center screen when entering insert mode'})
vim.keymap.set('n', '<Leader>set', ':tabnew $MYVIMRC<CR>', {desc = 'open MYVIMRC'})
vim.keymap.set('n', '<Leader>nd', ':lua require("custom_functions").delCurrentFile()<cr>', {desc = 'delete current file'})
vim.keymap.set('n', '<Leader>nc', ':lua require("custom_functions").currentLink()<cr>', {desc = 'copy link to current file'})
vim.keymap.set('n', '<leader>nl', '<esc>:lua require("custom_telescope").listOfNotes()<cr>', {desc = 'list all notes in reverse order'})
vim.keymap.set('n', '<leader>nf', '<esc>:MkdnEnter<cr>:lua require("custom_functions").currentLink()<cr>:MkdnGoBack<cr>o<esc>cc- <c-r>+<esc>kdd', {desc = 'change just ID to H1 ID'})
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
