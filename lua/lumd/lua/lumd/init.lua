local M = {}
local config = require("lumd.config")

-- Setup function with better error handling
function M.setup(opts)
  -- Initialize configuration
  local ok, err = pcall(config.setup, opts)
  if not ok then
    vim.notify("Failed to setup lumd configuration: " .. err, vim.log.levels.ERROR)
    return
  end

  M.get_selection = require("lumd.utils").buffer.get_visual_selection

  -- Core functionality - always available
  local create_ok, create = pcall(require, "lumd.create")
  if create_ok then
    M.create_note = create.create_note
    M.create_note_with_timestamp = create.create_note_with_timestamp

    -- Always create core commands
    vim.api.nvim_create_user_command("CreateNote", M.create_note, {})
    vim.api.nvim_create_user_command("CreateNoteWithTimestamp", M.create_note_with_timestamp, {})
  else
    vim.notify("Failed to load create module: " .. create, vim.log.levels.ERROR)
  end

  -- Vault management
  local vault_ok, vault = pcall(require, "lumd.vault")
  if vault_ok then
    M.switch_vault = vault.switch_vault
    M.list_vaults = vault.list_vaults
    M.add_vault = vault.add_vault
    M.remove_vault = vault.remove_vault

    -- Vault commands
    vim.api.nvim_create_user_command("SwitchVault", M.switch_vault, {})
    vim.api.nvim_create_user_command("ListVaults", M.list_vaults, {})
    vim.api.nvim_create_user_command("AddVault", M.add_vault, {})
    vim.api.nvim_create_user_command("RemoveVault", M.remove_vault, {})
  else
    vim.notify("Failed to load vault module: " .. vault, vim.log.levels.ERROR)
  end

  -- FzfLua integration
  if config.get("modules.fzf.enable") then
    local fzf_ok, fzf_module = pcall(require, "lumd.fzf")
    if fzf_ok then
      M.find_or_create_note = fzf_module.find_or_create_note
      vim.api.nvim_create_user_command("FindOrCreateNote", M.find_or_create_note, {})
    else
      vim.notify("notes-creator: FzfLua module enabled but not available", vim.log.levels.WARN)
    end
  end

  -- Refactor module
  if config.get("modules.refactor.enable") then
    local refactor_ok, refactor_module = pcall(require, "lumd.refactor")
    if refactor_ok then
      M.refactor_note = refactor_module.refactor_note
      M.refactor_note_interactive = refactor_module.refactor_note_interactive
      M.update_filename_from_frontmatter = refactor_module.update_filename_from_frontmatter

      vim.api.nvim_create_user_command("RefactorNote", function(opts)
        if opts.args and opts.args ~= "" then
          M.refactor_note(opts.args)
        else
          M.refactor_note()
        end
      end, { nargs = "?", complete = "file" })

      vim.api.nvim_create_user_command("RefactorNoteInteractive", M.refactor_note_interactive, {})
      vim.api.nvim_create_user_command("UpdateFilenameFromFrontmatter", M.update_filename_from_frontmatter, {})
    else
      vim.notify(
        "notes-creator: Refactor module failed to load:\n" .. tostring(refactor_module),
        vim.log.levels.ERROR
      )
    end
  end
end

return M
