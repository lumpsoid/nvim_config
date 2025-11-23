local opt = vim.opt

-- Tab settings
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true

-- Search settings
opt.smartcase = true
opt.ignorecase = true
opt.hlsearch = true

-- UI settings
opt.termguicolors = true
opt.number = true
-- opt.relativenumber = true

-- Cursor highlighting
vim.cmd.highlight({"Cursor", "guibg=#5f87af", "ctermbg=67"})
vim.cmd.highlight({"iCursor", "guibg=#ffffaf", "ctermbg=229"})
vim.cmd.highlight({"rCursor", "guibg=#d70000", "ctermbg=124"})
vim.o.guicursor = 'n-v-c:block-Cursor/lCursor,i-ci-ve:ver100-iCursor,r-cr:block-rCursor,o:hor50-Cursor/lCursor,sm:block-iCursor,a:blinkwait1000-blinkon500-blinkoff250'
