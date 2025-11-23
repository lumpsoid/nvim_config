local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Markdown settings
autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.cmd([[
      set awa
      set com=b:-,n:>
      set formatoptions+=ro
    ]])
  end,
})

-- Auto-stow dotfiles (adjust path as needed)
autocmd("BufWritePost", {
  pattern = "/home/qq/dotfiles/*",
  command = "!cd /home/qq/dotfiles; stow .",
})
