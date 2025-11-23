local map = vim.keymap.set

map({"n","v"}, "<leader>nc", "<Esc><cmd>lua require('config.qq.new').createNote()<CR>", { desc = "Create new note", silent = true })

-- Buffer management
map("n", "<leader>bc", "<cmd>bdelete<CR>", { desc = "Close current buffer", silent = true })

-- FZF
map("n", "<leader>fl", "<cmd>FzfLua lines<CR>", { desc = "fzf lines", silent = true })

-- File manager
map("n", "-", "<cmd>Oil<CR>", { desc = "Open file manager oil", silent = true })

-- Clipboard operations
map("n", "<leader>y", '"+yy', { desc = "Copy to clipboard normal", silent = true })
map("v", "<leader>y", '"+y', { desc = "Copy to clipboard visual", silent = true })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from clipboard", silent = true })

-- Window splits
map("n", "<leader>sv", "<cmd>vs<CR><c-w>w<CR>", { desc = "Split tab vertically and focus", silent = true })
map("n", "<leader>sh", "<cmd>sp<CR><c-w>w<CR>", { desc = "Split tab horizontally and focus", silent = true })

-- Custom functions
map("n", "<leader>fo", "<cmd>lua require('utils.fzf_extensions').openFile()<CR>",
  { desc = "Fuzzy find and open note", silent = true })
map("n", "<leader>gs", "<cmd>lua require('fzf-lua').lsp_document_symbols()<CR>",
  { desc = "LSP document symbols", silent = true })

local buf_opts = { buffer = true, silent = true }

map("n", "<leader>nb", "<cmd>lua require('utils.fzf_extensions').backlinks()<CR>",
  vim.tbl_extend("force", buf_opts, { desc = "Find backlinks" }))
map({ "i", "n" }, "<C-y>", "<esc>:lua require('utils.custom_functions').createID()<cr>jjA",
  vim.tbl_extend("force", buf_opts, { desc = "Create new zettel file" }))
map("n", "<leader>na", "<cmd>lua require('utils.fzf_extensions').findAroundNote()<CR>",
  vim.tbl_extend("force", buf_opts, { desc = "Find notes from same date" }))
map("n", "<leader>nd", "<cmd>lua require('utils.custom_functions').delCurrentFile()<CR>",
  vim.tbl_extend("force", buf_opts, { desc = "Delete current file" }))
map("n", "<leader>nl", "<cmd>lua require('utils.fzf_extensions').listOfNotes()<CR>",
  vim.tbl_extend("force", buf_opts, { desc = "List all notes" }))
map("n", "gh", "<esc>:e index.md<CR>",
  vim.tbl_extend("force", buf_opts, { desc = "Go home" }))
map("n", "<leader>jt", "<cmd>lua require('utils.custom_functions').openJournal()<CR>",
  vim.tbl_extend("force", buf_opts, { desc = "Open journal today" }))

map("n", "<leader>jl", "<cmd>lua require('utils.fzf_extensions').journalList()<CR>",
  vim.tbl_extend("force", buf_opts, { desc = "List journal entries" }))

--map({ "n", "i" }, "<C-t>", "<cmd>lua require('utils.fzf_extensions').insertTag()<CR>",
--  vim.tbl_extend("force", buf_opts, { desc = "Insert tags" }))
