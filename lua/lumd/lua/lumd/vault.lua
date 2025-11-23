local M = {}
local config = require("lumd.config")

-- Switch vault interactively
function M.switch_vault()
  local vaults = config.get_vaults()
  local current_vault = config.options.current_vault

  local vault_list = {}
  local display_list = {}

  for key, vault in pairs(vaults) do
    table.insert(vault_list, key)
    local marker = (key == current_vault) and "* " or "  "
    local display = string.format("%s%s - %s (%s)",
      marker, vault.name, vault.description or "", vault.path)
    table.insert(display_list, display)
  end

  vim.ui.select(display_list, {
    prompt = "Select vault:",
    format_item = function(item) return item end
  }, function(choice, idx)
    if choice and idx then
      local selected_vault = vault_list[idx]
      if config.switch_vault(selected_vault) then
        vim.notify(string.format("Switched to vault: %s (%s)",
          vaults[selected_vault].name,
          vaults[selected_vault].path), vim.log.levels.INFO)
      end
    end
  end)
end

-- List all vaults
function M.list_vaults()
  local vaults = config.get_vaults()
  local current_vault = config.options.current_vault

  local lines = { "Available vaults:" }
  for key, vault in pairs(vaults) do
    local marker = (key == current_vault) and "* " or "  "
    table.insert(lines, string.format("%s%s (%s) - %s",
      marker, vault.name, key, vault.path))
    if vault.description and vault.description ~= "" then
      table.insert(lines, string.format("    %s", vault.description))
    end
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

-- Add a new vault
function M.add_vault()
  vim.ui.input({ prompt = "Vault key (identifier): " }, function(key)
    if not key or key == "" then
      return
    end
    
    if config.options.vaults[key] then
      vim.notify("Vault with key '" .. key .. "' already exists", vim.log.levels.ERROR)
      return
    end
    
    vim.ui.input({ prompt = "Vault name: " }, function(name)
      if not name or name == "" then
        return
      end
      
      vim.ui.input({ prompt = "Vault path: " }, function(path)
        if not path or path == "" then
          return
        end
        
        vim.ui.input({ prompt = "Vault description (optional): " }, function(description)
          -- Add the new vault
          config.options.vaults[key] = {
            name = name,
            path = path,
            description = description or ""
          }
          
          vim.notify("Added vault: " .. name .. " (" .. key .. ")", vim.log.levels.INFO)
        end)
      end)
    end)
  end)
end

-- Remove a vault
function M.remove_vault()
  local vaults = config.get_vaults()
  local current_vault = config.options.current_vault
  
  -- Don't allow removing the current vault
  local removable_vaults = {}
  local display_list = {}
  
  for key, vault in pairs(vaults) do
    if key ~= current_vault then
      table.insert(removable_vaults, key)
      local display = string.format("%s - %s (%s)",
        vault.name, key, vault.path)
      table.insert(display_list, display)
    end
  end
  
  if #removable_vaults == 0 then
    vim.notify("No vaults available to remove", vim.log.levels.INFO)
    return
  end
  
  vim.ui.select(display_list, {
    prompt = "Select vault to remove:",
    format_item = function(item) return item end
  }, function(choice, idx)
    if choice and idx then
      local selected_vault = removable_vaults[idx]
      local vault_name = vaults[selected_vault].name
      
      vim.ui.select(
        { "Yes, remove " .. vault_name, "No, keep it" },
        { prompt = "Are you sure?" },
        function(choice)
          if choice and choice:match("^Yes") then
            config.options.vaults[selected_vault] = nil
            vim.notify("Removed vault: " .. vault_name, vim.log.levels.INFO)
          end
        end
      )
    end
  end)
end

return M
