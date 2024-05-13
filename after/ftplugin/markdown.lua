vim.keymap.set('n', '<leader>w', "<cmd>w<cr>", { silent = true, buffer = true })
vim.keymap.set({ 'i', 'n' }, '<C-k>', '<cmd>lua require("core.functions_fzf_lua").insertId()<CR>',
  { desc = 'for any note [[ID]] insert', buffer = true })
vim.keymap.set({ 'i', 'n' }, '<C-q>', '<cmd>lua require("core.functions_fzf_lua").insertHeadId()<CR>',
  { desc = 'tree note [[ID]] insert', buffer = true })
vim.keymap.set('n', '<leader>nb', '<cmd>lua require("core.functions_fzf_lua").backlinks()<cr>',
  { desc = 'find backlinks to open note', buffer = true })
vim.keymap.set('i', '<c-y>', '<esc>:lua require("core.custom_functions").createID()<cr>jjA',
  { desc = 'create new zettel file', buffer = true })
vim.keymap.set('n', '<leader>na', '<esc>:lua require("core.functions_fzf_lua").findAroundNote()<CR>',
  { desc = 'view notes which was created in the same date as current note', buffer = true, })
vim.keymap.set('n', '<Leader>nd', '<cmd>lua require("core.custom_functions").delCurrentFile()<CR>',
  { desc = 'delete current file', buffer = true })
vim.keymap.set('n', '<Leader>nc', '<cmd>lua require("core.custom_functions").currentLink()<CR>',
  { desc = 'copy link to current file', buffer = true })
vim.keymap.set('n', '<leader>nl', '<cmd>lua require("core.functions_fzf_lua").listOfNotes()<CR>',
  { desc = 'list all notes in reverse order', buffer = true })
vim.keymap.set('n', '<leader>nf',
  '<esc>:MkdnEnter<cr>:lua require("core.custom_functions").currentLink()<CR>:MkdnGoBack<cr>o<esc>cc- <c-r>+<esc>kdd',
  { desc = 'change just ID to H1 ID', buffer = true })
vim.keymap.set(
  'n',
  'gh',
  ':e index.md<CR>',
  { desc = 'go home', buffer = true }
)
