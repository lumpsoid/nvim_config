return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use 'stevearc/oil.nvim'
    -- пока не понимаю зачем именно
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    }
    -- автоматический свитчер layouts
    use 'lyokha/vim-xkbswitch'

    -- вставка картинок в формате md
    -- use 'ferrine/md-img-paste.vim'
    use 'ekickx/clipboard-image.nvim'



    -- VimWiki
    --  use 'vimwiki/vimwiki'
    -- Vim-Zettel
    --  use 'michal-h21/vim-zettel'
    -- Dependencic for vim-zettel
    -- fuzzy search
    -- use 'junegunn/fzf'
    -- use 'junegunn/fzf.vim'
    --  use 'alok/notational-fzf-vim'

    use({
        'jakewvincent/mkdnflow.nvim',
        rocks = 'luautf8', -- Ensures optional luautf8 dependency is installed
        ft = { 'md' },
        config = function () require(configs.mkdnflow-lazy) end
    })

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    -- sorting impruvement for telescope
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }

    use ({
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup ({
              -- your configuration comes here
              -- or leave it empty to use the default settings
              -- refer to the configuration section below
            })
        end
    })

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    -- удобно перемещаться по словам
    -- use 'easymotion/vim-easymotion'
    use {
        'phaazon/hop.nvim',
        branch = 'v2', -- optional but strongly recommended
    }
    use { 'RRethy/nvim-base16' }

    use {
        'ibhagwan/fzf-lua',
        -- optional for icon support
        requires = { 'nvim-tree/nvim-web-devicons' }
    }

    use { "lukas-reineke/indent-blankline.nvim" }

    use { 'gelguy/wilder.nvim', }

    use { 'vim-scripts/utl.vim', }

    use 'Vonr/align.nvim'
    -- Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
    use 'junegunn/vim-easy-align'

    --completion
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/nvim-cmp'
    use "L3MON4D3/LuaSnip"
    use 'saadparwaiz1/cmp_luasnip'
    use "rafamadriz/friendly-snippets"

    -- lsp config
    use {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
        --linting
        'jay-babu/mason-null-ls.nvim',
        'jose-elias-alvarez/null-ls.nvim',
    }
    --dap
    use {
        'mfussenegger/nvim-dap',
    }
    use {
        "rcarriga/nvim-dap-ui",
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
    }
    use {
        'mfussenegger/nvim-dap-python',
        ft = "python",
        config = function() require('configs.dap-python') end
    }
    --repl
    use {
        'Vigemus/iron.nvim',
        ft = "python",
        config = function() require('configs.iron-lazy') end
    }
end)
