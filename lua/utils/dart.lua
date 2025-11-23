local M = {}

function M.create_barrel_file()
  local current_file = vim.fn.expand('%:t')
  local current_dir = vim.fn.expand('%:p:h')

  -- Get all .dart files in current directory
  local dart_files = {}
  local files = vim.fn.readdir(current_dir)
  for _, file in ipairs(files) do
    if file:match('%.dart$') then
      table.insert(dart_files, file)
    end
  end

  -- Filter out current file
  local filtered_files = {}
  for _, file in ipairs(dart_files) do
    if file ~= current_file then
      table.insert(filtered_files, file)
    end
  end

  -- Get subdirectories (excluding hidden ones starting with .)
  local subdirs = {}
  for _, item in ipairs(files) do
    if not item:match('^%.') and vim.fn.isdirectory(current_dir .. '/' .. item) == 1 then
      table.insert(subdirs, item)
    end
  end

  -- Check subdirectories for matching dart files
  local folder_exports = {}
  for _, subdir in ipairs(subdirs) do
    local full_subdir_path = current_dir .. '/' .. subdir
    local matching_file = subdir .. '.dart'
    local matching_path = full_subdir_path .. '/' .. matching_file

    if vim.fn.filereadable(matching_path) == 1 then
      table.insert(folder_exports, subdir .. '/' .. matching_file)
    end
  end

  -- Combine and sort all exports
  local all_exports = {}
  for _, file in ipairs(filtered_files) do
    table.insert(all_exports, file)
  end
  for _, export in ipairs(folder_exports) do
    table.insert(all_exports, export)
  end

  table.sort(all_exports)

  if #all_exports > 0 then
    -- Clear buffer and insert export statements
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
    local lines = {}
    for _, export in ipairs(all_exports) do
      table.insert(lines, string.format("export '%s';", export))
    end
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

    print(string.format("Barrel file created with %d exports (%d files, %d folders)",
      #all_exports, #filtered_files, #folder_exports))
  else
    print("No .dart files or matching folders found in current directory")
  end
end

return M
