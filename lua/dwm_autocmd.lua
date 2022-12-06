vim.api.nvim_create_autocmd(
    { "BufWritePost" },
    { pattern = { "/home/qq/Documents/dwmblocks/config.h" }, command = "!cd /home/qq/Documents/dwmblocks; secret-tool lookup user iurii service sudo | sudo -S make install && { killall -q dwmblocks; setsid dwmblocks & }" }
)

vim.api.nvim_create_autocmd(
    { "BufWritePost" },
    { pattern = { "/home/qq/Documents/dwm/config.h" }, command = "!cd /home/qq/Documents/dwm; secret-tool lookup user iurii service sudo | sudo -S make install && sc-renewwm" }
)
