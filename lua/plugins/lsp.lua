return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }

          vim.keymap.set("n", "<leader>lew", "<cmd>FzfLua diagnostics_workspace<CR>", { desc = "fzf lines", silent = true })
          vim.keymap.set("n", "<leader>led", "<cmd>FzfLua diagnostics_document<CR>", { desc = "fzf lines", silent = true })

          -- Diagnostic keymaps
          vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
          vim.keymap.set("n", "<leader>len", vim.diagnostic.goto_next, opts)
          vim.keymap.set("n", "<leader>lep", vim.diagnostic.goto_prev, opts)

          -- LSP keymaps
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>lA", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, opts)
          vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
        end,
      })

      -- Server configurations
      local servers = {
        dartls = {
          cmd = { "dart", "language-server", "--protocol=lsp" },
          filetypes = { "dart" },
          root_markers = { 'pubspec.yaml' },
          init_options = {
            onlyAnalyzeProjectsWithOpenFiles = true,
            suggestFromUnimportedLibraries = false,
            closingLabels = true,
            outline = true,
            flutterOutline = true,
          },
          settings = {
            dart = {
              analysisExcludedFolders = {
                vim.fn.expand("$PUB_CACHE"),
                vim.fn.expand("$FLUTTER_ROOT"),
                vim.fn.expand("$XDG_DATA_HOME/dart"),
                vim.fn.expand("$XDG_CACHE_HOME/dart"),
              },
              updateImportsOnRename = true,
              completeFunctionCalls = true,
              showTodos = true,
            },
          },
        },
        harper_ls = {
          settings = {
            ["harper-ls"] = {
              linters = {
                sentence_capitalization = false,
              },
            },
          },
        },
        gopls = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        },
        bashls = {
          filetypes = { "sh", "bash" },
          settings = {
            bashIde = {
              globPattern = "*@(.sh|.inc|.bash|.command)",
            },
          },
        },
        ts_ls = {},
        nixd = {
          settings = {
            formatting = {
              command = { "alejandra" },
            },
          },
        },
        elixirls = {
          cmd = { vim.fn.expand("~/.local/share/elixir-ls/language_server.sh") },
          filetypes = { "elixir", "eex", "heex", "surface" },
          root_dir = function(fname)
            return lspconfig.util.root_pattern("mix.exs", ".git")(fname)
          end,
          init_options = {
            mixEnv = "dev",
          },
        },
        rust_analyzer = {},
      }

      for server, config in pairs(servers) do
        config.capabilities = capabilities
        lspconfig[server].setup(config)
      end
    end,
  },
}
