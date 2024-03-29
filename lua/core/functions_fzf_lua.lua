local M = {}
function M.backlinks()
    local note = require("core.custom_functions").currentNoteId()
    require('fzf-lua').grep({
      search = note,
      fzf_cli_args = '--preview-window=~1',
      fzf_opts = {
          ["--tiebreak"] = "length,begin",
      },
      previewer = 'bat',
      keymap = {
          fzf = {
              ["shift-down"] = "preview-half-page-down",
              ["shift-up"] = "preview-half-page-up",
          }
      },
      winopts = {
          preview = {
              horizontal = 'down:60%'
          }
      },
    })
end

function M.findAroundNote()
    local current_note = require("core.custom_functions").aroundNote()
    require('fzf-lua').files({
        cmd = "rg --files -g" .. " " .. current_note .. "*.md",
        fzf_cli_args = '--preview-window=~1',
        fzf_opts = {
            ["--tiebreak"] = "begin",
        },
        previewer = 'bat',
        keymap = {
            fzf = {
                ["shift-down"] = "preview-half-page-down",
                ["shift-up"] = "preview-half-page-up",
            }
        },
        winopts = {
            preview = {
                horizontal = 'down:60%'
            }
        },
})
end

function M.listOfNotes()
    require('fzf-lua').files({
        --cmd = "rg --files -g *.md --sortr=path",
        cmd = "rg --files -g *.md",
        fzf_cli_args = '--preview-window=~1',
        fzf_opts = {
            ["--tiebreak"] = "begin",
        },
        previewer = 'bat',
        keymap = {
            fzf = {
                ["shift-down"] = "preview-half-page-down",
                ["shift-up"] = "preview-half-page-up",
            }
        },
        winopts = {
            preview = {
                horizontal = 'down:60%'
            }
        },
})
end

function M.journalList()
    require('fzf-lua').files({
        cmd = "rg --files -g *_*_*.md | sort --reverse",
        --cmd = "rg --files | rg '[0-9]*_[0-9]*_[0-9]*.md' | sort --reverse",
        --cmd = 'rg [0-9]*_[0-9]*_[0-9]*.md',
        fzf_cli_args = '--preview-window=~1',
        fzf_opts = {
            ["--tiebreak"] = "begin",
        },
        previewer = 'bat',
        keymap = {
            fzf = {
                ["shift-down"] = "preview-half-page-down",
                ["shift-up"] = "preview-half-page-up",
            }
        }
})
end

function M.insertHeadId()
    require('fzf-lua').grep({
      search = '',
      fzf_cli_args = '--preview-window=~1',
      fzf_opts = {
          ["--tiebreak"] = "length,begin",
      },
      previewer = 'bat',
      keymap = {
          fzf = {
              ["shift-down"] = "preview-half-page-down",
              ["shift-up"] = "preview-half-page-up",
          }
      },
      winopts = {
          preview = {
              horizontal = 'down:60%'
          }
      },
      actions = {
        ['default'] = function(selected, opts)
            local cwd = vim.loop.cwd()
            local file_md = string.match(selected[1], "[0-9].*%.md")

            local path_to_file = cwd .. "/" .. file_md
            local file = io.open(path_to_file, "r")
            local header = file:read()
            file:close()

            local ztl_id = "[[" .. file_md:sub(1,-4) .. "]]"

            local output = require("core.custom_functions").cleanHeadline(header):lower() .. " " .. ztl_id
            vim.api.nvim_put({ output }, "", true, true)
          end
      }
    })
end

function M.insertId()
    require('fzf-lua').grep({
      search = '',
      fzf_cli_args = '--preview-window=~1',
      fzf_opts = {
            ["--tiebreak"] = "length,begin",
       },
      previewer = 'bat',
      keymap = {
          fzf = {
              ["shift-down"] = "preview-half-page-down",
              ["shift-up"] = "preview-half-page-up",
          }
      },
      winopts = {
          preview = {
              horizontal = 'down:60%'
          }
      },
      actions = {
        ['default'] = function(selected)
            --local file_md = string.match(selected[1], "[0-9]+%.md")
            local file_md = string.match(selected[1], "[0-9].*%.md")
            local ztl_id = "[[" .. file_md:sub(1,-4) .. "]]"
            vim.api.nvim_put({ ztl_id }, "", true, true)
          end
      }
    })
end

function M.openFile()
    require('fzf-lua').grep({
        search = '',
        fzf_cli_args = '--preview-window=~1',
        fzf_opts = {
            ["--tiebreak"] = "length,begin",
        },
        previewer = 'bat',
        keymap = {
            fzf = {
                ["shift-down"] = "preview-half-page-down",
                ["shift-up"] = "preview-half-page-up",
            }
        },
    })
end
return M
