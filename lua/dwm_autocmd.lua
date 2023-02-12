vim.api.nvim_create_autocmd(
    { "BufWritePost" },
    { pattern = { "/home/qq/Documents/dwmblocks/blocks.h" }, command = "!cd /home/qq/Documents/dwmblocks; secret-tool lookup user iurii service sudo | sudo -S make install && { killall -q dwmblocks; setsid dwmblocks & }" }
)

vim.api.nvim_create_autocmd(
    { "BufWritePost" },
    { pattern = { "/home/qq/.config/dwm/config.h" }, command = "!cd /home/qq/.config/dwm; secret-tool lookup user iurii service sudo | sudo -S make install && sc-renewwm" }
)

--vim.api.nvim_create_autocmd(
--    { "BufNewFile", "BufRead", "BufEnter" },
--    { pattern = { "*.md" }, command = 'syn match markdownIgnore "\w\@<=\w\@="' }
--)
