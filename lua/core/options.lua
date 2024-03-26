vim.g.mapleader = " "

vim.opt.termguicolors = true
-- ruller
vim.o.relativenumber = true
vim.o.number = true

vim.opt.cursorline = true
--vim.opt.comments = 'line'
-- Set the behavior of tab
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.hlsearch = false

--vim.cmd('colorscheme base16-brushtrees')
--vim.cmd('colorscheme base16-tokyo-night-terminal-dark')

--vim.cmd[[command! Resethl              lua require'custom_functions'.resethl()]]
--vim.cmd[[command! -bang -nargs=* Fzfnn call fzf#run(fzf#wrap({'source': 'ls -r', 'sink': 'e', 'options': '--preview="cat {}" --preview-window=up,wrap,~1 --multi'},<bang>0))]]
