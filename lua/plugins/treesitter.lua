return {
  'nvim-treesitter/nvim-treesitter',
  build = ':lua require("nvim-treesitter.install").update({ with_sync = true })',
  config = function()
    require'nvim-treesitter.configs'.setup {
      -- A list of parser names, or "all"
      ensure_installed = { "markdown", "lua", "python" },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = true,

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = false,

      -- List of parsers to ignore installing (for "all")
      --ignore_install = { "javascript" },

      ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
      -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
      indent = { enable = true },
      highlight = { 
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    }
  end
}
