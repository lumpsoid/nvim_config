local M = {}
local config = require("lumd.config")
local utils = require("lumd.utils")
local references = require("lumd.references")

-- Error handling
local function warn(message)
  vim.api.nvim_echo({ { message, 'WarningMsg' } }, true, {})
end

-- Validate file exists and is readable
local function validate_file(filepath)
  if not filepath or filepath == "" then
    return false, "No file specified"
  end

  if vim.fn.filereadable(filepath) == 0 then
    return false, "File does not exist: " .. filepath
  end

  return true
end

-- Extract date from filename
local function extract_date_from_filename(filename)
  return utils.date.extract_from_filename(filename)
end

-- Create link patterns for reference updates
local function create_link_patterns(old_date, new_filename_without_ext)
  return utils.link.create_patterns(old_date, new_filename_without_ext)
end

-- Get user input for title and tags
local function get_user_input(initial_title, initial_tags, callback)
  -- Get new title from user
  vim.ui.input({
    prompt = "Enter new title: ",
    default = initial_title
  }, function(new_title)
    if not new_title then
      vim.notify("Refactoring canceled", vim.log.levels.INFO)
      return
    end

    -- Get new tags from user
    local initial_tags_str = table.concat(initial_tags, ",")
    vim.ui.input({
      prompt = "Enter tags (comma separated): ",
      default = initial_tags_str
    }, function(tags_input)
      if tags_input == nil then
        vim.notify("Refactoring canceled", vim.log.levels.INFO)
        return
      end

      local new_tags = utils.string.parse_tags(tags_input)
      callback(new_title, new_tags)
    end)
  end)
end

-- Show proposed changes to user
local function confirm_changes(filename, new_filename)
  local changes_info = string.format(
    "Current filename: %s\nNew filename:     %s\n\nProceed with refactoring?",
    filename,
    new_filename
  )
  local choice = vim.fn.confirm(changes_info, "&Yes\n&No", 1)
  return choice == 1
end

-- Create new buffer with refactored content
local function create_new_buffer(filepath, new_filename, new_title, new_tags, formatted_date, identifier)
  -- Generate frontmatter
  local frontmatter = utils.file.generate_frontmatter(new_title, new_tags, formatted_date, identifier)

  -- Get content after header lines
  local content = utils.file.get_content_after_header(filepath)

  -- Create new buffer with refactored content
  local new_buffer = vim.api.nvim_create_buf(false, true) -- not listed, scratch buffer initially

  -- Set buffer name to new filename
  vim.api.nvim_buf_set_name(new_buffer, new_filename)

  -- Prepare all content
  local all_content = frontmatter .. (content or "")

  -- Insert as single string
  vim.api.nvim_buf_set_lines(new_buffer, 0, -1, false, vim.split(all_content, "\n", { plain = true }))

  -- Set filetype
  vim.api.nvim_buf_set_option(new_buffer, 'filetype', 'markdown')

  -- Make buffer modifiable and not scratch
  vim.api.nvim_buf_set_option(new_buffer, 'modifiable', true)
  vim.api.nvim_buf_set_option(new_buffer, 'buftype', '')

  -- Switch to the new buffer
  vim.api.nvim_set_current_buf(new_buffer)

  -- Position cursor at the end of frontmatter
  vim.cmd("normal! G")

  -- Save the new buffer
  vim.api.nvim_cmd({ cmd = 'write', args = { new_filename } }, {})

  return new_buffer
end

-- Update references and clean up
local function update_references_and_cleanup(old_link_pattern, new_link_pattern, directory, filepath)
  -- Check if auto update references is enabled
  if not config.get("modules.refactor.auto_update_references") then
    vim.notify("Auto reference updates disabled in configuration.", vim.log.levels.INFO)
  else
    -- Try to update references using user-provided function
    local updated = references.update_references(old_link_pattern, new_link_pattern, directory)
    if not updated then
      vim.notify("References were not updated. You may need to update them manually.", vim.log.levels.WARN)
    end
  end

  -- Close original buffer if it's open
  local original_bufnr = vim.fn.bufnr(filepath)
  if original_bufnr ~= -1 then
    vim.api.nvim_buf_delete(original_bufnr, { force = true })
  end

  -- Delete original file
  local success, err = os.remove(filepath)
  if not success then
    warn("Failed to delete original file: " .. (err or "unknown error"))
  end
end

-- Main refactor function
function M.refactor_note(filepath)
  -- If no filepath provided, try to get current buffer's file
  if not filepath then
    filepath = vim.api.nvim_buf_get_name(0)
    if not filepath or filepath == "" then
      vim.notify("No file specified and current buffer has no file", vim.log.levels.ERROR)
      return
    end
  end

  -- Validate file
  local valid, err_msg = validate_file(filepath)
  if not valid then
    vim.notify(err_msg, vim.log.levels.ERROR)
    return
  end

  local filename = vim.fn.fnamemodify(filepath, ":t")
  local directory = vim.fn.fnamemodify(filepath, ":h")

  -- Extract date from filename
  local date_string = extract_date_from_filename(filename)
  if not date_string then
    vim.notify("Could not extract date from filename. Expected format: YYYYMMDDHHMMSS", vim.log.levels.ERROR)
    return
  end

  -- Format date and create identifier
  local formatted_date = utils.date.format_for_frontmatter(date_string)
  local identifier = date_string:sub(1, 8) .. "T" .. date_string:sub(9, 14)

  -- Extract current title and tags
  local initial_title, initial_tags = utils.file.extract_title_and_tags(filepath)

  -- Get user input
  get_user_input(initial_title, initial_tags, function(new_title, new_tags)
    -- Build new filename
    local extension = config.get("file.extension")
    local new_filename = utils.file.build_filename(identifier, new_title, new_tags, extension)
    local new_filename_without_ext = vim.fn.fnamemodify(new_filename, ":r")

    -- Create link patterns for reference updates
    local old_link_pattern, new_link_pattern = create_link_patterns(date_string, new_filename_without_ext)

    -- Show user the proposed changes
    warn("Current filename: %s, New filename:%s")
    --if not confirm_changes(filename, new_filename) then
    --  vim.notify("Refactoring canceled", vim.log.levels.INFO)
    --  return
    --end

    -- Create new buffer with refactored content
    create_new_buffer(filepath, new_filename, new_title, new_tags, formatted_date, identifier)

    -- Update references and clean up
    vim.defer_fn(function()
      update_references_and_cleanup(old_link_pattern, new_link_pattern, directory, filepath)
    end, 100)
  end)
end

-- Interactive file selection for refactoring
function M.refactor_note_interactive()
  -- Get current buffer info for default
  local current_file = vim.api.nvim_buf_get_name(0)
  local default_file = nil
  local default_dir = config.get_current_path()

  -- Check if current buffer matches pattern
  if current_file and current_file ~= "" then
    local filename = vim.fn.fnamemodify(current_file, ":t")
    if filename:match("%.md$") and filename:match("%d%d%d%d%d%d%d%d%d%d%d%d%d%d") then
      default_file = current_file
      default_dir = vim.fn.fnamemodify(current_file, ":h")
    end
  end

  -- Use vim.ui.select if available (better UX), otherwise fall back to input
  local notes_pattern = default_dir .. "/*." .. config.get("file.extension")
  local files = vim.fn.glob(notes_pattern, false, true)

  if #files == 0 then
    vim.notify("No note files found in " .. default_dir, vim.log.levels.INFO)
    return
  end

  -- Filter files that match the timestamp pattern
  local refactorable_files = {}
  for _, file in ipairs(files) do
    local filename = vim.fn.fnamemodify(file, ":t")
    if filename:match("%d%d%d%d%d%d%d%d%d%d%d%d%d%d") then
      table.insert(refactorable_files, file)
    end
  end

  if #refactorable_files == 0 then
    vim.notify("No refactorable files found (must have YYYYMMDDHHMMSS pattern)", vim.log.levels.INFO)
    return
  end

  -- Create display names
  local display_items = {}
  for _, file in ipairs(refactorable_files) do
    local filename = vim.fn.fnamemodify(file, ":t")
    local title, tags = utils.file.extract_title_and_tags(file)
    local display = filename
    if title and title ~= "" then
      display = display .. " - " .. title
    end
    if #tags > 0 then
      display = display .. " [" .. table.concat(tags, ", ") .. "]"
    end
    table.insert(display_items, { display = display, file = file })
  end

  vim.ui.select(display_items, {
    prompt = "Select note to refactor:",
    format_item = function(item) return item.display end
  }, function(choice)
    if choice then
      M.refactor_note(choice.file)
    end
  end)
end

-- Update filename based on frontmatter
function M.update_filename_from_frontmatter(opts)
  opts = opts or {}
  local current_file = vim.api.nvim_buf_get_name(0)

  if not current_file or current_file == "" then
    warn("No file in current buffer")
    return
  end

  -- Check if file exists
  if vim.fn.filereadable(current_file) == 0 then
    warn("Current buffer file does not exist on disk")
    return
  end

  -- Get buffer content
  local content_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Parse frontmatter
  local frontmatter, err = utils.file.parse_frontmatter(content_lines)
  if not frontmatter then
    warn("Failed to parse frontmatter: " .. (err or "unknown error"))
    return
  end

  -- Validate required fields
  if not frontmatter.identifier then
    warn("Missing 'identifier' field in frontmatter")
    return
  end

  if not frontmatter.date then
    warn("Missing 'date' in frontmatter")
    return
  end

  if not frontmatter.title then
    warn("Missing 'title' field in frontmatter")
    return
  end

  -- Derive new date core from identifier
  local iso_date = utils.date.identifier_to_iso_date(frontmatter.identifier)
  if not iso_date then
    warn("Invalid identifier format: " .. frontmatter.identifier)
    return
  end

  -- Preserve original timezone
  local tz = utils.date.extract_timezone(frontmatter.date)
  local new_date = iso_date .. tz

  -- Rebuild frontmatter as lines
  local new_frontmatter_lines = {
    '---',
    string.format('title:      "%s"', frontmatter.title or ""),
    string.format('date:       %s', new_date),
  }

  -- Rebuild tags if present
  if frontmatter.tags and #frontmatter.tags > 0 then
    local tag_str = 'tags:       [' ..
        table.concat(vim.tbl_map(function(t) return '"' .. t .. '"' end, frontmatter.tags), ', ') .. ']'
    table.insert(new_frontmatter_lines, tag_str)
  end

  table.insert(new_frontmatter_lines, string.format('identifier: "%s"', frontmatter.identifier))
  table.insert(new_frontmatter_lines, '---')

  -- Find end of original frontmatter (look for closing ---)
  local frontmatter_end = 1
  for i, line in ipairs(content_lines) do
    if i > 1 and line:match("^%s*---%s*$") then
      frontmatter_end = i
      break
    end
  end

  -- Build updated content: new frontmatter + rest of file after old frontmatter
  local content_after_frontmatter = vim.list_slice(content_lines, frontmatter_end + 1, #content_lines)
  local updated_content = vim.list_extend(new_frontmatter_lines, content_after_frontmatter)

  -- Write back to buffer
  vim.api.nvim_buf_set_lines(0, 0, #content_lines, false, updated_content)

  -- Generate new filename
  local extension = config.get("file.extension")
  local new_filename = utils.file.build_filename(
    frontmatter.identifier,
    frontmatter.title,
    frontmatter.tags or {},
    extension
  )

  local directory = vim.fn.fnamemodify(current_file, ":h")
  local new_filepath = directory .. "/" .. new_filename
  local old_filename = vim.fn.fnamemodify(current_file, ":t")

  -- Check if target exists
  local target_exists = vim.fn.filereadable(new_filepath) == 1
  local warning_msg = ""
  if target_exists then
    warning_msg = "\n\nWARNING: Target file already exists and will be overwritten!"
  end

  -- Show user the proposed changes
  local changes_info = string.format(
    "Update filename based on frontmatter:\n\nCurrent: %s\nNew:     %s%s\n\nProceed with rename?",
    old_filename,
    new_filename,
    warning_msg
  )

  local choice = vim.fn.confirm(changes_info, "&Yes\n&No", 2)
  if choice ~= 1 then
    return
  end

  -- Rename the file
  local success, rename_err = os.rename(current_file, new_filepath)
  if not success then
    warn("Failed to rename file: " .. (rename_err or "unknown error"))
    return
  end

  -- Update buffer name
  vim.api.nvim_buf_set_name(0, new_filepath)

  -- Mark buffer as not modified since we just saved it with new name
  vim.api.nvim_buf_set_option(0, 'modified', false)

  -- Get create_link_patterns from opts first, then fallback to config
  local create_link_patterns = opts.create_link_patterns or
      (config.get("modules.refactor.enable") and
        config.get("modules.refactor.create_link_patterns"))

  -- Check if create_link_patterns is a function before using it
  if create_link_patterns and type(create_link_patterns) == "function" then
    -- Ask about updating references
    vim.defer_fn(function()
      local update_refs = vim.fn.confirm(
        "Update references to this file in other notes?",
        "&Yes\n&No",
        1
      )
      if update_refs == 1 then
        -- Use custom link pattern creator
        local old_link_pattern, new_link_pattern
        old_link_pattern, new_link_pattern = create_link_patterns(
          old_filename,
          new_filename
        )
        -- Use custom reference update function if provided
        if opts.update_references then
          opts.update_references(old_link_pattern, new_link_pattern, directory)
        else
          -- Try to update references using user-provided function
          local updated = references.update_references(old_link_pattern, new_link_pattern, directory)
          if not updated then
            vim.notify("References were not updated. You may need to update them manually.", vim.log.levels.WARN)
          end
        end
      end
    end, 100)
  elseif create_link_patterns then
    -- If create_link_patterns exists but isn't a function, notify the user
    warn("create_link_patterns must be a function")
  end
end

return M
