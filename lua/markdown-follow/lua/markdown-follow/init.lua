local config = require('markdown-follow.config')
local follow = require('markdown-follow.follow')

local M = {}

-- Setup function for the plugin
function M.setup(opts)
  config.setup(opts)

  M.follow_link = follow.follow_link
  vim.api.nvim_create_user_command("MdFollowLink", M.follow_link, {})
end

return M
