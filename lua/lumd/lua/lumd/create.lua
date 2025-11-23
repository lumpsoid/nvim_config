local M = {}
local utils = require("lumd.utils")
local config = require("lumd.config")

-- Create note with current timestamp
function M.create_note(opts)
  opts = opts or {}
  opts.timestamp = opts.timestamp or utils.date.generate_timestamp()

  local selection = utils.buffer.get_visual_selection()
  if selection then
    -- We are in visual mode
    opts.title = selection.text
    opts.is_visual_mode = true
    opts.original_buf = vim.api.nvim_get_current_buf()
    opts.selection = selection
  else
    -- We are in normal mode, proceed as before
    opts.is_visual_mode = false
  end
  M._create_note_with_timestamp(opts)
end

-- Create note with custom timestamp
function M.create_note_with_timestamp()
  vim.ui.input({ prompt = "Enter timestamp (YYYYMMDDTHHMMSS): " }, function(timestamp)
    if timestamp and timestamp ~= "" then
      -- Validate timestamp format
      if not timestamp:match("^%d%d%d%d%d%d%d%dT%d%d%d%d%d%d$") then
        vim.notify("Invalid timestamp format. Use YYYYMMDDTHHMMSS", vim.log.levels.ERROR)
        return
      end
      M._create_note_with_timestamp({ timestamp = timestamp })
    end
  end)
end

-- Internal function to create note with given timestamp
function M._create_note_with_timestamp(opts)
  opts = opts or {}
  local initial_title = opts.title or utils.buffer.get_current_line_as_title()

  -- Get title from user
  vim.ui.input({
    prompt = "Note title: ",
    default = initial_title
  }, function(title)
    if not title then
      return -- User canceled
    end

    -- Get tags from user
    vim.ui.input({
      prompt = "Tags (comma separated): "
    }, function(tags_str)
      if tags_str == nil then
        return -- User canceled
      end

      local tags = utils.string.parse_tags(tags_str)

      -- Generate file details
      local filename = utils.file.build_filename(opts.timestamp, title, tags)
      local filepath = config.get_current_path() .. "/" .. filename

      -- Check if file already exists
      if vim.fn.filereadable(filepath) == 1 then
        local choice = vim.fn.confirm(
          "File already exists. What would you like to do?",
          "&Overwrite\n&Cancel\n&Choose different name",
          2
        )
        if choice == 2 then
          return -- Cancel
        elseif choice == 3 then
          vim.ui.input({
            prompt = "New title: ",
            default = title
          }, function(new_title)
            if new_title then
              filename = utils.file.build_filename(opts.timestamp, new_title, tags)
              filepath = config.get_current_path() .. "/" .. filename
              M._create_file(filepath, new_title, tags, opts.timestamp, opts.text)
            end
          end)
          return
        end
      end

      M._create_file(filepath, title, tags, opts.timestamp, opts.text, opts)
    end)
  end)
end

function M._create_file(filepath, title, tags, timestamp, text, opts)
  opts = opts or {}
  -- Generate frontmatter
  local date_formatted = utils.date.format_for_frontmatter(timestamp)
  local frontmatter = utils.file.generate_frontmatter(title, tags, date_formatted, timestamp)

  -- Create and open file
  local file = io.open(filepath, "w")
  if not file then
    vim.notify("Error: Could not create file " .. filepath, vim.log.levels.ERROR)
    return
  end

  -- Write frontmatter
  file:write(frontmatter)

  -- Write text content if provided
  if text and text ~= "" then
    file:write(text)
  end

  file:close()

  print(opts.is_visual_mode)
  if opts.is_visual_mode then
    local original_buf = vim.api.nvim_get_current_buf()
    local selection = opts.selection

    -- Create the markdown link text
    -- Using a relative path is usually best for markdown links
    local relative_path = vim.fn.fnamemodify(filepath, ":.")
    local link_text = string.format("[%s](%s)", title, relative_path)

    -- Replace the visual selection with the link
    -- Note: API functions are 0-indexed, while `getpos` is 1-indexed.
    local start_line = selection.start_pos.line - 1
    local start_col = selection.start_pos.col - 1
    local end_line = selection.end_pos.line - 1
    -- The `'>` mark column is exclusive, which is what nvim_buf_set_text expects.
    local end_col = selection.end_pos.col

    vim.api.nvim_buf_set_text(original_buf, start_line, start_col, end_line, end_col, { link_text })
  end

  -- Open the file in Neovim
  vim.cmd("edit " .. vim.fn.fnameescape(filepath))

  -- Move cursor to appropriate position
  if text and text ~= "" then
    -- If text was provided, move to end of file
    vim.cmd("normal! G")
  else
    -- If no text, move to end of frontmatter for editing
    vim.cmd("normal! G")
  end
end

return M
