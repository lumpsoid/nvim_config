return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

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

    -- Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
    use 'junegunn/vim-easy-align'

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
    use {
        'RRethy/nvim-base16'
    }
    -- минималистичный вид для написания текстов
    -- use 'junegunn/goyo.vim'
end)
