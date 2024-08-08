local wk = require('which-key')

wk.add({
  {
    mode = "n",
    { "<C-S>", "<cmd>wa<CR>", desc = "Save file" },
    { "i", "zzi", desc = "center screen when entering insert mode" },
    {
      { "<leader>set", '<cmd>tabnew $MYVIMRC<CR>', desc = "open VIMRC" },
      { "<leader>sv",  '<cmd>vs<CR><c-w>w<CR>',    desc = "Vertical split, and focus on it" },
      { "<leader>sh",  '<cmd>sp<CR>',              desc = "Horizontal split" },
    },
    {
      group = "clipboard",
      { "<leader>y", '"+yy', desc = "Yank to clipboard" },
      { "<leader>y", '"+y', mode = "v",                  desc = "Yank to clipboard" },
      { "<leader>p", '"+p', desc = "Past from clipboard" },
    },
    {
      group = "tabs",
      { "<leader>tn", "<cmd>tabnew<CR>",      desc = "New tab" },
      { "<leader>tc", "<cmd>tabclose<CR>",    desc = "Close tab" },
      { "<leader>tl", "<cmd>tabnext<CR>",     desc = "Next tab" },
      { "<leader>th", "<cmd>tabprevious<CR>", desc = "Previous tab" },
    },
    {
      group = "hop",
      { "<leader>gc", "<cmd>HopChar1MW<CR>", desc = "1 char hop" },
      { ",j", ":HopLineMW", desc = "two way line" },
      { "<leader>gl", "<cmd>lua require('core.hop-custom').hint_wikilink_follow()<CR>", desc = "two way line" },
    },
    {
      group = "oil",
      { "-", "<cmd>lua require('oil').open()<CR>",   desc = "Open parent directory" },
    },
    {
      group = "fzf",
      { "<leader>sf", "<cmd>lua require('fzf-lua').files()<CR>",                   desc = "fzf search filenames" },
      { "<leader>sb", "<cmd>lua require('fzf-lua').buffers()<CR>",                 desc = "fzf search buffers" },
      { "<leader>h",  "<cmd>FzfLua oldfiles<CR>",                                  desc = "open history pane" },
      { "<leader>fo", "<cmd>lua require('core.functions_fzf_lua').openFile()<CR>", desc = "find and open note with fuzzy" },
    },
    {
      group = "notes",
      { "<leader>ti", "<cmd>lua require('core.functions_fzf_lua').insertTag()<CR>", desc = "Tags autocomplition with fzf" },
    },
    {
      group = "calendar",
      { "<leader>jo", "<cmd>Calendar<CR>",                                                  desc = "open calendar" },
      { "<leader>jt", "<cmd>lua require('core.custom_functions').openJournal()<CR>",        desc = "open todays daily note" },
      { "<leader>jn", "<cmd>lua require('core.custom_functions').openJournalShift(1)<CR>",  desc = "open next daily note" },
      { "<leader>jp", "<cmd>lua require('core.custom_functions').openJournalShift(-1)<CR>", desc = "open previous daily note" },
      { "<leader>js", "<cmd>lua require('core.custom_functions').openJournalSameDay()<CR>", desc = "open journal note for the same date" },
      { "<leader>jl", "<cmd>lua require('core.functions_fzf_lua').journalList()<CR>",       desc = "open list of all journals" },
    },
  },
})

-- Mappings
--complition
local ls = require("luasnip")
vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end, { silent = true })
--calendar/journal
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

vim.keymap.set('x', 'aa', function() require 'align'.align_to_char(1, true) end, NS)            -- Aligns to 1 character, looking left
vim.keymap.set('x', 'as', function() require 'align'.align_to_char(2, true, true) end, NS)      -- Aligns to 2 characters, looking left and with previews
vim.keymap.set('x', 'aw', function() require 'align'.align_to_string(false, true, true) end, NS) -- Aligns to a string, looking left and with previews
vim.keymap.set('x', 'ar', function() require 'align'.align_to_string(true, true, true) end, NS) -- Aligns to a Lua pattern, looking left and with previews
