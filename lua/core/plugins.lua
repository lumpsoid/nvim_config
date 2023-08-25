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
    'nvim-tree/nvim-web-devicons',
    {
      "NeogitOrg/neogit",
      dependencies = {
        "nvim-lua/plenary.nvim",         -- required
        --"nvim-telescope/telescope.nvim", -- optional
        "sindrets/diffview.nvim",        -- optional
      },
      config = true
    },
    {
        'stevearc/oil.nvim',
        config = function()
            require('core.configs.oil-setup')
        end
    },
    -- пока не понимаю зачем именно
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':lua require("nvim-treesitter.install").update({ with_sync = true })',
        config = function()
            require('core.configs.treesitter-setup')
        end
    },
    -- автоматический свитчер layouts
    {
        'lyokha/vim-xkbswitch',
        enabled = true,
        init = function ()
            vim.g.XkbSwitchLib = '/home/qq/.config/xkb-switch/build/libxkbswitch.so'
            vim.g.XkbSwitchEnabled = 1
        end
    },

    -- вставка картинок в формате md
    -- use 'ferrine/md-img-paste.vim'
    --'ekickx/clipboard-image.nvim',

    {
        'mattn/calendar-vim',
        config = function ()
            require('core.configs.calendar-setup')
        end

    },
    {
        'jakewvincent/mkdnflow.nvim',
        ft = { 'markdown' },
        config = function ()
            require('core.configs.mkdnflow-setup')
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
        enabled = true,
        dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
        config = function()
            require('core.configs.lualine-setup')
        end
    },
    -- удобно перемещаться по словам
    -- use 'easymotion/vim-easymotion'
    {
        'phaazon/hop.nvim',
        branch = 'v2', -- optional but strongly recommended
        config = function()
            require('core.configs.hop-setup')
        end
    },
    { 
        'RRethy/nvim-base16',
        config = function()
            --vim.cmd('colorscheme base16-atelier-dune-light')
            vim.cmd('colorscheme base16-ayu-mirage')
            vim.cmd('colorscheme base16-framer')
        end
    },
    {
        'ibhagwan/fzf-lua',
        -- optional for icon support
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function ()
            --require('fzf-lua').setup({'skim'})
           require('fzf-lua').setup()
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require('core.configs.indent-blankline')
        end
    },
    {
        'gelguy/wilder.nvim',
        config = function()
            require('core.configs.wilder')
        end
    },
    { 'vim-scripts/utl.vim', },
    'Vonr/align.nvim',
    -- Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
    'junegunn/vim-easy-align',
    --completion
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'rafamadriz/friendly-snippets',
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {} -- this is equalent to setup({}) function
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'windwp/nvim-autopairs',
            'hrsh7th/cmp-nvim-lsp',
            'L3MON4D3/LuaSnip',
            'rafamadriz/friendly-snippets',
        },
        config = function()
            require('core.configs.cmp-setup')
        end
    },

    {"nvim-lua/plenary.nvim"},
    -- lsp config
    {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        ft = {
            'python',
            'rust',
            'lua',
            'cpp',
        },
        config = function()
            require('core.configs.mason-lsp-setup')
        end
    },
    --linting
    {'jay-babu/mason-null-ls.nvim'},
    {
        'jose-elias-alvarez/null-ls.nvim',
        ft = { "python", "markdown" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            'jay-babu/mason-null-ls.nvim',
        },
        config = function ()
            require('core.configs.mason-null-ls')
        end
    },
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
            require('core.configs.dap-python')
        end
    },
    --repl
    {
        "dccsillag/magma-nvim",
        version = "*",
        --build = 'UpdateRemotePlugins',
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
            require('core.configs.magma-setup')
        end,
    },
}

local opts = {}

require("lazy").setup(plugins, opts)
