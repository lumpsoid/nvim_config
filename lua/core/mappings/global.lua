MapReg = function(opts)
  return function(mappings)
    return require('which-key').register(mappings, opts)
  end
end

MapLeaderNormal = MapReg({ mode = 'n', prefix = '<leader>' })
MapCtrlNormal = MapReg({ mode = 'n', prefix = 'ctrl' })
MapLeaderVisual = MapReg({ mode = 'v', prefix = '<leader>' })

MapLeaderNormal({
  s = {
    e = {
      t = { ":tabnew $MYVIMRC<CR>", "open VIMRC" },
    },
    v = { ':vs<CR><c-w>w', 'Vertical split, and focus on it' },
    h = { ':sp<CR>', 'Horizontal split' },
    n = { '<cmd>lua require("luasnip").jump(1)<CR>', 'next snippet placeholder' },
    p = { '<cmd>lua require("luasnip").jump(-1)<CR>', 'previous snippet placeholder' },
    f = { require('fzf-lua').files, 'fzf search filenames' },
    b = { require('fzf-lua').buffers, 'fzf search buffers' },
  },
  y = { '"+y', 'Yank to clipboard' },
  p = { '"+p', 'Paste from clipboard' },
  t = {
    n = { ':tabnew<CR>', 'New tab' },
    c = { ':tabclose<CR>', 'Close tab' },
    l = { ':tabnext<CR>', 'Next tab' },
    h = { ':tabprevious<CR>', 'Previous tab' },
    i = {
      '<cmd>lua require("core.functions_fzf_lua").insertTag()<CR>',
      'Tags autocomplition with fzf'
    },
  },
  h = { '<cmd>FzfLua oldfiles<CR>', 'open history pane' },
  j = {
    o = { '<cmd>Calendar<CR>', 'open calendar' },
    t = { '<cmd>lua require("core.custom_functions").openJournal()<CR>', 'open todays daily note' },
    n = { '<cmd>lua require("core.custom_functions").openJournalShift(1)<CR>', 'open next daily note' },
    p = { '<cmd>lua require("core.custom_functions").openJournalShift(-1)<CR>', 'open previous daily note' },
    s = { '<cmd>lua require("core.custom_functions").openJournalSameDay()<CR>', 'open journal note for the same date' },
    l = { '<cmd>lua require("core.functions_fzf_lua").journalList()<CR>', 'open list of all journals' },
  },
})

MapLeaderVisual({
  y = {'"+y', 'copy to clipboard'},
})
-- Mappings
vim.keymap.set('n', '<c-s>', ':wa<cr>', {desc = 'Save file'})
--something
vim.keymap.set('n', 'i', 'zzi', {desc = 'center screen when entering insert mode'})

vim.keymap.set('n', '<leader>fo', '<cmd>lua require("core.functions_fzf_lua").openFile()<CR>', {desc = 'find and open note through telescope'})
vim.keymap.set('n', '<leader>bl', '<cmd>lua require("fzf-lua").blines()<CR>', {desc = 'поиск по открытым buffers'})
--complition
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

vim.keymap.set('x', 'aa', function() require'align'.align_to_char(1, true)             end, NS) -- Aligns to 1 character, looking left
vim.keymap.set('x', 'as', function() require'align'.align_to_char(2, true, true)       end, NS) -- Aligns to 2 characters, looking left and with previews
vim.keymap.set('x', 'aw', function() require'align'.align_to_string(false, true, true) end, NS) -- Aligns to a string, looking left and with previews
vim.keymap.set('x', 'ar', function() require'align'.align_to_string(true, true, true)  end, NS) -- Aligns to a Lua pattern, looking left and with previews
