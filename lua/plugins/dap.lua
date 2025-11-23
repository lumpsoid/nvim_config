return {
  {
    "mfussenegger/nvim-dap",                -- DAP Plugin
    event = { "BufReadPre", "BufNewFile" }, -- Lazy load on Dart/Flutter files
    dependencies = {
      "rcarriga/nvim-dap-ui",               -- DAP UI for visual debugging
      "theHamsta/nvim-dap-virtual-text",    -- Optional: for inline debug information
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')

      -- Dart/Flutter Adapter Configuration
      dap.adapters.dart = {
        type = "executable",
        command = "flutter",
        args = { "debug_adapter" }
      }

      -- Dart/Flutter Debug Configurations
      dap.configurations.dart = {
        {
          type = "dart",
          request = "launch",
          name = "Launch Flutter Program (main_development.dart)",
          program = "lib/main_development.dart",
          cwd = "${workspaceFolder}",
          toolArgs = { "--flavor", "development" },
        },
        {
          type = "dart",
          request = "attach",
          name = "Connect flutter",
          cwd = "${workspaceFolder}",
        },
      }

      -- Set up DAP UI to automatically open and close with the debug session
      dap.listeners.after['dap.init'] = function()
        dapui.open()
      end

      dap.listeners.before['dap.exit'] = function()
        dapui.close()
      end

      dapui.setup()

      -- Optional: Configure virtual text for DAP
      require('nvim-dap-virtual-text').setup()

      -- Keybindings for debugging
      vim.api.nvim_set_keymap('n', '<F5>', ':lua require"dap".continue()<CR>', { noremap = true })
      vim.api.nvim_set_keymap('n', '<F10>', ':lua require"dap".step_over()<CR>', { noremap = true })
      vim.api.nvim_set_keymap('n', '<F11>', ':lua require"dap".step_into()<CR>', { noremap = true })
      vim.api.nvim_set_keymap('n', '<F12>', ':lua require"dap".step_out()<CR>', { noremap = true })
      vim.api.nvim_set_keymap('n', '<leader>b', ':lua require"dap".toggle_breakpoint()<CR>', { noremap = true })
      -- Keybinding to manually open DAP UI
      vim.api.nvim_set_keymap('n', '<leader>du', ':lua require("dapui").open()<CR>', { noremap = true, silent = true })
      -- Keybinding to manually close DAP UI
      vim.api.nvim_set_keymap('n', '<leader>dc', ':lua require("dapui").close()<CR>', { noremap = true, silent = true })
      -- Keybinding for Hot Reload (<leader>dl)
      vim.keymap.set('n', '<leader>dl', function()
        -- Ensure there is an active debug session before proceeding.
        -- If not, `assert` will show the error message and stop.
        local session = assert(dap.session(), "No active DAP session for hot reload")

        -- Send the 'hotReload' request with an inline function to handle the response.
        session:request("hotReload", nil, function(err, result)
          if err then
            vim.notify("Hot Reload Failed: " .. err.message, vim.log.levels.ERROR)
          else
            vim.notify("Hot Reload Successful!", vim.log.levels.INFO)
          end
        end)
      end, { desc = 'Dart: Hot Reload with feedback' })
      -- Keybinding for Hot Restart (<leader>dr)
      vim.keymap.set('n', '<leader>dr', function()
        -- Ensure there is an active debug session.
        local session = assert(dap.session(), "No active DAP session for hot restart")

        -- Send the 'hotRestart' request with an inline function to handle the response.
        session:request("hotRestart", nil, function(err, result)
          if err then
            vim.notify("Hot Restart Failed: " .. err.message, vim.log.levels.ERROR)
          else
            vim.notify("Hot Restart Successful!", vim.log.levels.INFO)
          end
        end)
      end, { desc = 'Dart: Hot Restart with feedback' })
    end,
  },
}
