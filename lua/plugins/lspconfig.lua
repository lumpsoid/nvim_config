return {
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
      'javascript',
      'html',
      'css',
      'markdown',
      'bash',
      'sh',
    },
    config = function()
      require("mason").setup({ ensure_installed = { "debugpy", "clang-format" }, })
      require("mason-lspconfig").setup {
        ensure_installed = {
          "lua_ls",
          --"rust_analyzer",
          "pyright",
          "sqlls",
          "bashls",
          "cssls",
          "html",
          "clangd",
          "tsserver",
        },
      }

      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', '<space>q', require('fzf-lua').lsp_document_diagnostics, opts)

      local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gD', require('fzf-lua').lsp_declarations, bufopts)
        vim.keymap.set('n', 'gs', require('fzf-lua').lsp_document_symbols, bufopts)
        vim.keymap.set('n', 'gd', require('fzf-lua').lsp_definitions, bufopts)
        vim.keymap.set("n", "gr", require('fzf-lua').lsp_references, bufopts)
        vim.keymap.set('n', 'gi', require('fzf-lua').lsp_implementations, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set('n', '<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
        --vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
        --vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
        vim.keymap.set("n", "<leader>ca", require('fzf-lua').lsp_code_actions, bufopts)
      end

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      require("lspconfig").lua_ls.setup {
        on_attach = on_attach,
        capabilitites = capabilities
      }
      require("lspconfig").pyright.setup {
        on_attach = on_attach,
        capabilitites = capabilities
      }
      require("lspconfig").rust_analyzer.setup {
        on_attach = on_attach,
        capabilitites = capabilities
      }
      require("lspconfig").clangd.setup {
        on_attach = on_attach,
        capabilitites = capabilities
      }
      require("lspconfig").tsserver.setup {
        on_attach = on_attach,
        capabilitites = capabilities
      }
      require("lspconfig").bashls.setup {
        on_attach = on_attach,
        capabilitites = capabilities
      }
    end
  },
  --linting
  { 'jay-babu/mason-null-ls.nvim' },
  {
    'jose-elias-alvarez/null-ls.nvim',
    ft = { "python", "markdown" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      'jay-babu/mason-null-ls.nvim',
    },
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = {
          -- Opt to list sources here, when available in mason.
          'ltrs',
        },
        automatic_installation = false,
        handlers = {},
      })
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          -- Anything not supported by mason.
          --null_ls.builtins.diagnostics.ltrs,
          null_ls.builtins.formatting.clang_format,
          null_ls.builtins.diagnostics.ltrs,
        }
      })
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
    config = function()
      local path_python = '~/.local/share/nvim/mason/packages/debugpy/venv/bin/python'
      require('dap-python').setup(path_python)
    end
  },
  --repl
  {
    enable = false,
    "dccsillag/magma-nvim",
    version = "*",
    --build = 'UpdateRemotePlugins',
    keys = {
      { "<leader>mi", "<cmd>MagmaInit<CR>",             desc = "This command initializes a runtime for the current buffer." },
      { "<leader>mo", "<cmd>MagmaEvaluateOperator<CR>", desc = "Evaluate the text given by some operator." },
      { "<leader>ml", "<cmd>MagmaEvaluateLine<CR>",     desc = "Evaluate the current line." },
      { "<leader>mv", "<cmd>MagmaEvaluateVisual<CR>",   desc = "Evaluate the selected text." },
      { "<leader>mc", "<cmd>MagmaEvaluateOperator<CR>", desc = "Reevaluate the currently selected cell." },
      { "<leader>mr", "<cmd>MagmaRestart!<CR>",         desc = "Shuts down and restarts the current kernel." },
      {
        "<leader>mx",
        "<cmd>MagmaInterrupt<CR>",
        desc = "Interrupts the currently running cell and does nothing if not cell is running.",
      },
    },
    config = function()
      vim.g.magma_image_provider = "none"
      vim.g.magma_automatically_open_output = false

      vim.keymap.set('n', '<leader>rx', "<cmd>lua vim.api.nvim_exec('MagmaEvaluateOperator', true)<cr>",
        { desc = 'Magma: eval operator' })
      vim.keymap.set('n', '<leader>rl', '<cmd>MagmaEvaluateLine<cr>', { desc = 'Magma: run line' })
      vim.keymap.set('x', '<leader>r', ':<C-u>MagmaEvaluateVisual<cr>', { desc = 'Magma: run visual' })
      vim.keymap.set('n', '<leader>rb', 'vip:<C-u>MagmaEvaluateVisual<cr>', { desc = 'Magma: run current block' })
      vim.keymap.set('n', '<leader>rr', ':MagmaReevaluateCell<cr>', { desc = 'Magma: Re-evaluate cell' })
      vim.keymap.set('n', '<leader>ro', ':MagmaShowOutput<cr>', { desc = 'Magma: Show output' })
      vim.keymap.set('n', '<leader>q', ':noautocmd MagmaEnterOutput<cr>', { desc = 'Magma: Enter output' })

      --nnoremap <silent> <LocalLeader>rd :MagmaDelete<CR>
      --nnoremap <silent> <LocalLeader>rq :noautocmd MagmaEnterOutput<CR>
    end,
  },
}
