local M = {}

-- Default configuration
M.defaults = {
  wiki_extension = "md" -- Default extension for wiki links without extension
}

-- Current configuration (starts as defaults)
M.options = vim.deepcopy(M.defaults)

-- Setup function to merge user config with defaults
function M.setup(user_config)
  M.options = vim.tbl_deep_extend("force", M.defaults, user_config or {})
end

return M
