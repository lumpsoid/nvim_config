local M = {}
local config = require("lumd.config")

-- Default reference update function (can be overridden by user)
function M.update_references(old_pattern, new_pattern, directory)
  local user_callback = config.get("reference.update_callback")
  if user_callback and type(user_callback) == "function" then
    user_callback(old_pattern, new_pattern, directory)
    return true
  end
  
  -- No user callback provided, skip reference updates
  vim.notify("No reference update function provided. Skipping reference updates.", vim.log.levels.INFO)
  return false
end

return M
