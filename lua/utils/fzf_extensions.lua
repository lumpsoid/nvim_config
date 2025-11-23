local cf = require("utils.custom_functions") -- Updated path
local M = {}

-- Your existing functions with some improvements for consistency
function M.backlinks()
  local note = cf.currentNoteId()
  require('fzf-lua').live_grep({
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
  local noteId = cf.currentNoteId():gsub('_', '')
  local noteDate = cf.todayFromNoteId(noteId)
  local year = string.sub(noteDate, 1, 4)
  local month = string.sub(noteDate, 5, 6)
  local day = string.sub(noteDate, 7, 8)
  local query = string.format("rg --files | rg -e %s_?%s_?%s.* | sort --reverse", year, month, day)
  
  require('fzf-lua').files({
    cmd = query,
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
    cmd = "rg --files -g *.md | sort --reverse",
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
  require('fzf-lua').live_grep({
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
        local cwd = vim.loop.cwd()
        local file_md = string.match(selected[1], "[0-9].*%.md")
        local path_to_file = cwd .. "/" .. file_md
        local file = io.open(path_to_file, "r")
        if file == nil then
          return
        end
        local header = file:read()
        file:close()
        local ztl_id = "[[" .. file_md:sub(1, -4) .. "]]"
        local output = ztl_id .. " " .. cf.cleanHeadline(header):lower()
        cf.textInsert(output)
      end
    }
  })
end

function M.insertId()
  require('fzf-lua').live_grep({
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
        local file_md = string.match(selected[1], "[0-9].*%.md")
        local ztl_id = "[[" .. file_md:sub(1, -4) .. "]]"
        cf.textInsert(ztl_id)
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

function M.insertTag()
  require('fzf-lua').fzf_exec("cat .tags_index", {
    fzf_opts = {
      ["--tiebreak"] = "length,begin",
      ["--multi"] = true,
    },
    keymap = {
      fzf = {
        ["ctrl-x"] = "clear-query",
      },
    },
    actions = {
      ['default'] = function(selected)
        if next(selected) == nil then
          print("Nothing was selected")
          return
        end
        local text = {}
        for _, tag in ipairs(selected) do
          local tagString = string.match(tag, "#.*")
          table.insert(text, tagString)
        end
        local textString = table.concat(text, " ")
        vim.api.nvim_put({ textString }, "", true, true)
      end,
    },
  })
end

return M
