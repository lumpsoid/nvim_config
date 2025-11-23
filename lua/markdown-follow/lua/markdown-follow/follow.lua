local utils = require('markdown-follow.utils')
local parser = require('markdown-follow.parser')

local M = {}

-- Main function to follow link
function M.follow_link()
  local link = parser.get_link_under_cursor()
  if not link then
    return -- Do nothing if no link found
  end

  -- Handle URLs
  if utils.is_url(link) then
    local open_cmd = utils.get_open_command()
    vim.system({ open_cmd, link }, {
      detach = true, -- Don't wait for the process to finish
    })
    return
  end

  -- Handle local files
  local filepath = utils.resolve_path(link)

  if utils.is_text_file(filepath) then
    -- Open text file in Neovim (create buffer if doesn't exist)
    vim.cmd("edit " .. vim.fn.fnameescape(filepath))
  else
    -- Open non-text file with system default program
    local open_cmd = utils.get_open_command()
    vim.system({ open_cmd, filepath }, {
      detach = true,
    })
  end
end

return M
