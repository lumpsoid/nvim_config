local hop = require('hop')
local jump_regex = require('hop.jump_regex')
local mkdnflow_links = require('mkdnflow.links')

local M = {}

function M.hint_wikilink_follow()
  local opts = {
    keys = 'asdghklqwertyuiopzxcvbnmfj',
    multi_windows = true,
  }

  hop.hint_with_regex(
    jump_regex.regex_by_case_searching("[[", true, opts),
    opts,
    function(jt)
      hop.move_cursor_to(
        jt.window,
        jt.line + 1,
        jt.column - 1, opts.hint_offset, opts.direction
      )
      mkdnflow_links.followLink()
    end
  )
end

return M
