local M = {}

function M.insertHeadId()
    require('fzf-lua').grep({
      search = '',
      fzf_cli_args = '--preview-window=~1',
      previewer = 'bat',
      keymap = {
          fzf = {
              ["shift-down"] = "preview-half-page-down",
              ["shift-up"] = "preview-half-page-up",
          }
      },
      actions = {
        ['default'] = function(selected, opts)
            local cwd = vim.loop.cwd()
            local file_md = string.match(selected[1], "[0-9]+%.md")

            local path_to_file = cwd .. "/" .. file_md
            local file = io.open(path_to_file, "r")
            local header = file:read()
            file:close()

            local ztl_id = "[[" .. file_md:sub(1,14) .. "]]"

            local output = require("custom_functions").cleanHeadline(header):lower() .. " " .. ztl_id
            vim.api.nvim_put({ output }, "", false, true)
          end
      }
    })
end

function M.insertId()
    require('fzf-lua').grep({
      search = '',
      fzf_cli_args = '--preview-window=~1',
      previewer = 'bat',
      keymap = {
          fzf = {
              ["shift-down"] = "preview-half-page-down",
              ["shift-up"] = "preview-half-page-up",
          }
      },
      actions = {
        ['default'] = function(selected)
            local file_md = string.match(selected[1], "[0-9]+%.md")
            local ztl_id = "[[" .. file_md:sub(1,14) .. "]]"
            vim.api.nvim_put({ ztl_id }, "", false, true)
          end
      }
    })
end

return M
