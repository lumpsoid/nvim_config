vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
       vim.cmd([[
           set awa
           set com=b:-,n:>
           set formatoptions+=ro
       ]])
       --vim.opt.listchars:append({space = '|'})
    end
})
--vim.api.nvim_create_autocmd(
--    { "BufEnter" }, 
--    {
--        pattern = "*.md", 
--        callback = function()
--            vim.cmd([[source /home/qq/.config/nvim/lua/core/mappings/md-mappings.lua]])
--       --vim.opt.listchars:append({space = '|'})
--        end
--    }
--)
--vim.api.nvim_create_autocmd(
--    { "BufLeave" },
--    { pattern = { "*.md" }, command = "w" }
--)
--dotfiles stow
vim.api.nvim_create_autocmd(
    { "BufWritePost" },
    { pattern = { "/home/qq/dotfiles/*" }, command = "!cd /home/qq/dotfiles; stow ." }
)
--dwmblocks
vim.api.nvim_create_autocmd(
    { "BufWritePost" },
    { pattern = { "/home/qq/.config/dwmblocks/config.h" }, command = "!cd /home/qq/.config/dwmblocks; pass sudo | su -c 'make install && { killall -q dwmblocks; setsid dwmblocks & }'" }
)
--dwm
vim.api.nvim_create_autocmd(
    { "BufWritePost" },
    { pattern = { "/home/qq/.config/dwm/config.h" }, command = "!cd /home/qq/.config/dwm; pass sudo | su -c 'make install && sc-renewwm'" }
)
--st terminal
vim.api.nvim_create_autocmd(
    { "BufWritePost" },
    { pattern = { "/home/qq/.config/st/config.h" }, command = "!cd /home/qq/.config/st; pass sudo | su -c 'make install'" }
)
--vim.api.nvim_create_autocmd(
--    { "BufNewFile", "BufRead", "BufEnter" },
--    { pattern = { "*.md" }, command = 'syn match markdownIgnore "\w\@<=\w\@="' }
--)
