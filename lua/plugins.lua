local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


local plugins = {

    'wbthomason/packer.nvim',

    'stevearc/oil.nvim',
    -- пока не понимаю зачем именно
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':lua require("nvim-treesitter.install").update({ with_sync = true })',
    },
    -- автоматический свитчер layouts
    {
        'lyokha/vim-xkbswitch',
        enabled = false,
        config = function ()
            --vim.g['XkbSwitchEnabled'] = 1
            --vim.g.XkbSwitchLib = '/home/qq/Applications/xkb-switch/build/libxkbswitch.so'
        end
    },

    -- вставка картинок в формате md
    -- use 'ferrine/md-img-paste.vim'
    'ekickx/clipboard-image.nvim',

    {
        'jakewvincent/mkdnflow.nvim',
        ft = { 'markdown' },
        config = function ()
            require('configs.mkdnflow-setup')
        end
    },

    {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup ({
              -- your configuration comes here
              -- or leave it empty to use the default settings
              -- refer to the configuration section below
            })
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', opt = true }
    },
    -- удобно перемещаться по словам
    -- use 'easymotion/vim-easymotion'
    {
        'phaazon/hop.nvim',
        branch = 'v2', -- optional but strongly recommended
    },
    { 'RRethy/nvim-base16' },
    {
        'ibhagwan/fzf-lua',
        -- optional for icon support
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    { "lukas-reineke/indent-blankline.nvim" },
    { 'gelguy/wilder.nvim', },
    { 'vim-scripts/utl.vim', },
    'Vonr/align.nvim',
    -- Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
    'junegunn/vim-easy-align',
    --completion
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/nvim-cmp',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'rafamadriz/friendly-snippets',
    -- lsp config
    {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    },
    --linting
    {
        'jose-elias-alvarez/null-ls.nvim',
        dependencies = {
            "nvim-lua/plenary.nvim",
            'jay-babu/mason-null-ls.nvim',
        },
    },
    {'jay-babu/mason-null-ls.nvim'},
    {"nvim-lua/plenary.nvim"},
    --dap
    {
        'mfussenegger/nvim-dap',
        lazy = true
    },
    {
        'rcarriga/nvim-dap-ui',
        lazy = true,
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },
    {
        'mfussenegger/nvim-dap-python',
        ft = 'python',
        dependencies = {
            'mfussenegger/nvim-dap',
            'rcarriga/nvim-dap-ui',
        },
        config = function ()
            require('configs.dap-python')
        end
    },
    --repl
    {
        'Vigemus/iron.nvim',
        enabled = false,
        ft = "python",
        config = function ()
            require('configs.iron-setup')
        end,
    },
    {
        "WhiteBlackGoose/magma-nvim-goose",
        enabled = true,
        version = "*",
        run = "UpdateRemotePlugins",
        keys = {
            { "<leader>mi", "<cmd>MagmaInit<CR>", desc = "This command initializes a runtime for the current buffer." },
            { "<leader>mo", "<cmd>MagmaEvaluateOperator<CR>", desc = "Evaluate the text given by some operator." },
            { "<leader>ml", "<cmd>MagmaEvaluateLine<CR>", desc = "Evaluate the current line." },
            { "<leader>mv", "<cmd>MagmaEvaluateVisual<CR>", desc = "Evaluate the selected text." },
            { "<leader>mc", "<cmd>MagmaEvaluateOperator<CR>", desc = "Reevaluate the currently selected cell." },
            { "<leader>mr", "<cmd>MagmaRestart!<CR>", desc = "Shuts down and restarts the current kernel." },
            {
                "<leader>mx",
                "<cmd>MagmaInterrupt<CR>",
                desc = "Interrupts the currently running cell and does nothing if not cell is running.",
            },
        },
        config = function ()
            require('configs.magma-setup')
        end,
    },
}

local opts = {}

require("lazy").setup(plugins, opts)
