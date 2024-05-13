local hop = require('hop')
local jump_target = require'hop.jump_target'
local mkdnflow_links = require('mkdnflow.links')

local M = {}

function M.hint_wikilink_follow(pattern)
  local opts = {
    keys = 'asdghklqwertyuiopzxcvbnmfj',
    quit_key = '<Esc>',
    perm_method = require'hop.perm'.TrieBacktrackFilling,
    reverse_distribution = false,
    teasing = true,
    jump_on_sole_occurrence = true,
    case_insensitive = true,
    create_hl_autocmd = true,
    current_line_only = false,
    uppercase_labels = false,
    multi_windows = true,
    hint_position = require'hop.hint'.HintPosition.BEGIN,
    hint_offset = 0
  }

  local generator = jump_target.jump_targets_by_scanning_lines

  hop.hint_with_callback(
    generator(jump_target.regex_by_case_searching(pattern, false, opts)),
    opts,
    function(jt)
        hop.move_cursor_to(jt.window, jt.line + 1, jt.column - 1, opts.hint_offset, opts.direction)
        mkdnflow_links.followLink()
    end
  )
end

return M
