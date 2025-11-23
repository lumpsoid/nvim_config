-- Set a vertical line at the 80th column to visually indicate a character limit
vim.opt_local.colorcolumn = "80"

vim.opt_local.formatoptions:append("c") -- Enable comment continuation
vim.opt_local.formatoptions:append("r") -- Enable continuation of comments when pressing Enter
