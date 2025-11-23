-- Set leader key before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load filetype configuration
require("filetype")

-- Load core configuration
require("config.colors")
require("config.options")
require("config.keymaps")
require("config.autocmds")
require('config.commands')
require("config.lazy")
