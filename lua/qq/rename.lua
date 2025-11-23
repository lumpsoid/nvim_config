local M = {}

function M.update_links(old_pattern, new_pattern, directory)
  -- Set default directory if not provided
  if not directory then
    directory = vim.fn.getcwd()
  end
  -- Check for required tools
  if vim.fn.executable("rg") == 0 or vim.fn.executable("sd") == 0 then
    vim.notify("This function requires both 'rg' and 'sd' to be installed and in your PATH", vim.log.levels
      .ERROR)
    return
  end
  -- Escape arguments for shell
  local escaped_old = vim.fn.shellescape(old_pattern)
  local escaped_new = vim.fn.shellescape(new_pattern)
  local escaped_dir = vim.fn.shellescape(directory)
  -- Build the command using the exact same logic as Emacs version
  local cmd = string.format("sd -F %s %s $(rg --files-with-matches -F --glob '*.{md,org,txt}' %s)",
    escaped_old,
    escaped_new,
    escaped_old)
  -- Change to the target directory and run the command
  local old_cwd = vim.fn.getcwd()
  vim.fn.chdir(directory)
  local result = vim.fn.system(cmd)
  local exit_code = vim.v.shell_error
  -- Restore original directory
  vim.fn.chdir(old_cwd)
  -- Handle the result
  if exit_code ~= 0 then
    vim.notify(string.format("There was an error updating references. Exit code: %d\nOutput: %s",
      exit_code, result), vim.log.levels.ERROR)
  end
  return exit_code == 0
end

return M
