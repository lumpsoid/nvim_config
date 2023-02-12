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
--    { "BufLeave" },
--    { pattern = { "*.md" }, command = "w" }
--)
