vim.g.mapleader = " "

-- ruller
vim.o.relativenumber = true
vim.o.number = true

vim.opt.cursorline = true
--vim.opt.comments = 'line'
-- Set the behavior of tab
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

--vim.opt.listchars:append({space = '|'})

require('packer-plugin')
require('my_remaps')
require('custom_autocmd')

vim.cmd('colorscheme base16-gruvbox-dark-soft')

vim.cmd[[command! Resethl              lua require'custom_functions'.resethl()]]
vim.cmd[[command! -bang -nargs=* Fzfnn call fzf#run(fzf#wrap({'source': 'ls -r', 'sink': 'e', 'options': '--preview="cat {}" --preview-window=up,wrap,~1 --multi'},<bang>0))]]

vim.api.nvim_create_autocmd(
    { "BufWritePost" },
    { pattern = { "/home/qq/Documents/dwmblocks/config.h" }, command = "!cd /home/qq/Documents/dwmblocks; secret-tool lookup user iurii service sudo | sudo -S make install && { killall -q dwmblocks; setsid dwmblocks & }" }
)

vim.api.nvim_create_autocmd(
    { "BufWritePost" },
    { pattern = { "/home/qq/Documents/dwm/config.h" }, command = "!cd /home/qq/Documents/dwm; secret-tool lookup user iurii service sudo | sudo -S make install && sc-renewwm" }
)
