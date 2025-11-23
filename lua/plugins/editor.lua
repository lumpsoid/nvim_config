return {
  --{
  --  "windwp/nvim-autopairs",
  --  event = "InsertEnter",
  --  opts = {},
  --},
  {
    "stevearc/oil.nvim",
    opts = {
      view_options = {
        show_hidden = true,
      },
    },
  },
  {
    "smoka7/hop.nvim",
    version = "*",
    opts = {},
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>sf", "<cmd>FzfLua files<cr>",    desc = "Fzf search filenames" },
      { "<leader>sb", "<cmd>FzfLua buffers<cr>",  desc = "Fzf search buffers" },
      { "<leader>h",  "<cmd>FzfLua oldfiles<cr>", desc = "Open history pane" },
    },
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = true,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      auto_install = true,
      ensure_installed = {
        "markdown",
        "lua",
        "go",
        "dart",
        "todotxt",
      },
      fold = {
        enable = true,
      },
      indent = {
        enable = true,
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      --custom_captures = {
        -- Capture Markdown inline links (URLs)
        --["markdown_inline.link"] = "Link", -- Links will be captured as "Link"
      --},
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      -- Set up conceal behavior for Markdown files
--      vim.cmd([[
--   autocmd FileType markdown setlocal conceallevel=2 concealcursor=nv
--]])

      -- Highlight links (optional: if you want to customize the appearance)
--      vim.cmd([[
--  highlight Link ctermfg=blue guifg=#8abbed
--]])
    end,
  },
}
