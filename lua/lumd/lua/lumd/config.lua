local M = {}

-- Default configuration with better organization
M.defaults = {
  -- File settings
  file = {
    extension = "md",
    date_format = "%Y%m%dT%H%M%S",
    frontmatter_date_format = "%Y-%m-%dT%H:%M:%S%z",
  },
  
  -- Reference settings
  reference = {
    update_callback = nil, -- User-defined function for updating references
  },
  
  -- Multi-vault support
  vaults = {
    default = {
      name = "Default",
      path = nil,
      description = "Main notes collection"
    }
  },
  current_vault = "default",
  
  -- Module configuration
  modules = {
    fzf = {
      enable = true,
      preview_lines = 20,
      create_new_text = "📝 Create new note",
    },
    refactor = {
      enable = true,
      create_link_patterns = nil,
      auto_update_references = true,
    },
  },
}

M.options = {}

-- Validate configuration options
local function validate_config(opts)
  -- Validate file settings
  if opts.file then
    if opts.file.extension and type(opts.file.extension) ~= "string" then
      error("file.extension must be a string")
    end
    if opts.file.date_format and type(opts.file.date_format) ~= "string" then
      error("file.date_format must be a string")
    end
    if opts.file.frontmatter_date_format and type(opts.file.frontmatter_date_format) ~= "string" then
      error("file.frontmatter_date_format must be a string")
    end
  end
  
  -- Validate vaults
  if opts.vaults then
    for key, vault in pairs(opts.vaults) do
      if not vault.name or type(vault.name) ~= "string" then
        error("vaults[" .. key .. "].name must be a string")
      end
      if not vault.path or type(vault.path) ~= "string" then
        error("vaults[" .. key .. "].path must be a string")
      end
    end
  end
  
  -- Validate modules
  if opts.modules then
    if opts.modules.fzf and type(opts.modules.fzf) ~= "table" then
      error("modules.fzf must be a table")
    end
    if opts.modules.refactor and type(opts.modules.refactor) ~= "table" then
      error("modules.refactor must be a table")
    end
  end
  
  -- Validate reference update callback
  if opts.reference and opts.reference.update_callback and type(opts.reference.update_callback) ~= "function" then
    error("reference.update_callback must be a function")
  end
end

function M.setup(opts)
  validate_config(opts or {})
  M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

-- Get current vault info
function M.get_current_vault()
  return M.options.vaults[M.options.current_vault]
end

-- Get all vaults
function M.get_vaults()
  return M.options.vaults
end

-- Switch to a different vault
function M.switch_vault(vault_key)
  if M.options.vaults[vault_key] then
    M.options.current_vault = vault_key
    return true
  end
  return false
end

-- Get current vault's path
function M.get_current_path()
  return M.get_current_vault().path
end

-- Get a specific configuration value
function M.get(path)
  local parts = vim.split(path, ".", { plain = true })
  local value = M.options
  
  for _, part in ipairs(parts) do
    if value[part] then
      value = value[part]
    else
      return nil
    end
  end
  
  return value
end

return M
