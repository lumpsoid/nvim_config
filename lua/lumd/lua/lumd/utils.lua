local M = {}
local config = require("lumd.config")

-- String utilities
M.string = {}

-- Clean and format title for filename
function M.string.clean_title(title)
  if not title or title == "" then
    return "untitled"
  end
  -- Convert to lowercase
  local cleaned = title:lower()
  -- Replace spaces and underscores with dashes
  cleaned = cleaned:gsub("[%s_]+", "-")
  -- Remove punctuation and control characters, but keep Unicode letters, numbers, and dashes
  cleaned = cleaned:gsub("[%c%z]", "")                                -- Remove control and null characters
  cleaned = cleaned:gsub("[!\"#$%%&'()*+,/:;<=>?@%[%\\%]^`{|}~]", "") -- Remove specific punctuation but keep dashes
  -- Remove multiple consecutive dashes
  cleaned = cleaned:gsub("-+", "-")
  -- Remove leading/trailing dashes
  cleaned = cleaned:gsub("^-+", ""):gsub("-+$", "")

  -- Check if we ended up with an empty string after cleaning
  if cleaned == "" then
    return "untitled"
  end

  return cleaned
end

-- Parse tags from comma-separated string
function M.string.parse_tags(tags_str)
  if not tags_str or tags_str == "" then
    return {}
  end
  local tags = {}
  for tag in tags_str:gmatch("([^,]+)") do
    local trimmed = tag:match("^%s*(.-)%s*$") -- trim whitespace from both ends
    if trimmed and trimmed ~= "" then
      table.insert(tags, trimmed)
    end
  end
  return tags
end

-- Date utilities
M.date = {}

-- Generate timestamp
function M.date.generate_timestamp(format)
  format = format or config.get("file.date_format")
  return os.date(format)
end

-- Format date for frontmatter
function M.date.format_for_frontmatter(date_string)
  if not date_string or #date_string ~= 14 then
    return os.date(config.get("file.frontmatter_date_format"))
  end
  local year = date_string:sub(1, 4)
  local month = date_string:sub(5, 6)
  local day = date_string:sub(7, 8)
  local hour = date_string:sub(9, 10)
  local min = date_string:sub(11, 12)
  local sec = date_string:sub(13, 14)
  -- Create timestamp and format with timezone
  local timestamp = os.time({
    year = tonumber(year),
    month = tonumber(month),
    day = tonumber(day),
    hour = tonumber(hour),
    min = tonumber(min),
    sec = tonumber(sec)
  })
  return os.date(config.get("file.frontmatter_date_format"), timestamp)
end

-- Extract date from filename (YYYYMMDDHHMMSS format)
function M.date.extract_from_filename(filename)
  local date_match = filename:match("(%d%d%d%d%d%d%d%d%d%d%d%d%d%d)")
  return date_match
end

-- Format identifier to ISO date string (without timezone)
function M.date.identifier_to_iso_date(id)
  -- id = "20250730T211547"
  if not id or #id < 15 then return nil end
  local year  = id:sub(1, 4)
  local month = id:sub(5, 6)
  local day   = id:sub(7, 8)
  local hour  = id:sub(10, 11)
  local min   = id:sub(12, 13)
  local sec   = id:sub(14, 15)
  return string.format("%s-%s-%sT%s:%s:%s", year, month, day, hour, min, sec)
end

-- Extract timezone suffix like +0200, -0500, Z, etc.
function M.date.extract_timezone(date_str)
  -- Match optional timezone at end: +0200, -0800, Z, etc.
  local tz = date_str:match("([%+%-]%d%d%d%d)$") or date_str:match("(Z)$")
  return tz or "" -- return empty if none
end

-- File utilities
M.file = {}

-- Generate frontmatter
function M.file.generate_frontmatter(title, tags, date_formatted, identifier)
  local frontmatter = "---\n"
  frontmatter = frontmatter .. string.format('title:      "%s"\n', title)
  frontmatter = frontmatter .. string.format('date:       %s\n', date_formatted)

  if tags and #tags > 0 then
    local tags_str = '["' .. table.concat(tags, '", "') .. '"]'
    frontmatter = frontmatter .. string.format('tags:       %s\n', tags_str)
  else
    frontmatter = frontmatter .. 'tags:       []\n'
  end

  frontmatter = frontmatter .. string.format('identifier: "%s"\n', identifier)
  frontmatter = frontmatter .. "---\n\n"

  return frontmatter
end

-- Build filename
function M.file.build_filename(timestamp, title, tags, extension)
  local cleaned_title = M.string.clean_title(title)
  local filename = timestamp .. "--" .. cleaned_title

  if tags and #tags > 0 then
    local cleaned_tags = {}
    for _, tag in ipairs(tags) do
      table.insert(cleaned_tags, M.string.clean_title(tag))
    end
    filename = filename .. "__" .. table.concat(cleaned_tags, "_")
  end

  return filename .. "." .. (extension or config.get("file.extension"))
end

-- Extract title and tags from file content
function M.file.extract_title_and_tags(filepath)
  local file = io.open(filepath, "r")
  if not file then
    return "", {}
  end
  local first_line = file:read("line")
  local second_line = file:read("line")
  file:close()
  -- Extract title from first line (remove # and trim)
  local title = ""
  if first_line and first_line:match("^#%s(.+)") then
    title = first_line:match("^#%s(.+)")
  end
  -- Extract tags from second line
  local tags = {}
  if second_line then
    for tag in second_line:gmatch("#(%w+)") do
      table.insert(tags, tag)
    end
  end
  return title, tags
end

-- Read file content starting from the third line
function M.file.get_content_after_header(filepath)
  local file = io.open(filepath, "r")
  if not file then
    return ""
  end
  local lines = {}
  local line_count = 0
  for line in file:lines() do
    line_count = line_count + 1
    if line_count > 2 then -- Skip first two lines
      table.insert(lines, line)
    end
  end
  file:close()
  return table.concat(lines, "\n")
end

-- Parse YAML frontmatter from buffer content
function M.file.parse_frontmatter(content_lines)
  local in_frontmatter = false
  local frontmatter_lines = {}
  local content_start_line = 1
  -- Check if file starts with frontmatter
  if content_lines[1] and content_lines[1]:match("^%-%-%-$") then
    in_frontmatter = true
    for i = 2, #content_lines do
      local line = content_lines[i]
      if line:match("^%-%-%-$") then
        content_start_line = i + 1
        break
      end
      table.insert(frontmatter_lines, line)
    end
  else
    return nil, "No frontmatter found"
  end
  -- Parse YAML fields we need
  local frontmatter = {}
  for _, line in ipairs(frontmatter_lines) do
    -- Parse title
    local title = line:match('^title:%s*"([^"]*)"') or line:match('^title:%s(.+)$')
    if title then
      frontmatter.title = title:gsub('^"', ''):gsub('"$', ''):gsub("^'", ""):gsub("'$", "")
    end
    -- Parse identifier
    local identifier = line:match('^identifier:%s"([^"])"') or line:match('^identifier:%s(.+)$')
    if identifier then
      frontmatter.identifier = identifier:gsub('^"', ''):gsub('"$', ''):gsub("^'", ""):gsub("'$", "")
    end
    -- Parse date
    local date = line:match('^date:%s*"([^"]*)"') or line:match('^date:%s*(.+)$')
    if date then
      frontmatter.date = date:gsub('^"', ''):gsub('"$', ''):gsub("^'", ""):gsub("'$", "")
    end
    -- Parse tags
    local tags_match = line:match('^tags:%s*%[(.-)%]$')
    if tags_match then
      frontmatter.tags = {}
      for tag in tags_match:gmatch('"([^"]*)"') do
        table.insert(frontmatter.tags, tag)
      end
    end
  end
  return frontmatter, nil
end

-- Buffer utilities
M.buffer = {}

-- Get current line as initial title
function M.buffer.get_current_line_as_title()
  local line = vim.api.nvim_get_current_line()
  -- Remove markdown headers, bullets, etc.
  line = line:gsub("^%s*#+%s*", "")    -- Remove markdown headers
  line = line:gsub("^%s*%-%s*", "")    -- Remove bullet points
  line = line:gsub("^%s*%*%s*", "")    -- Remove asterisk bullets
  line = line:gsub("^%s*%d+%.%s*", "") -- Remove numbered lists
  line = line:match("^%s*(.-)%s*$")    -- Trim whitespace
  return line
end

-- Helper function to get the current visual selection
-- Returns a table with text, start_pos, and end_pos, or nil if not in visual mode.
function M.buffer.get_visual_selection()
  -- Get the start and end positions of the last visual selection
  -- vim.fn.getpos returns: [bufnum, lnum, col, off]
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  -- If the marks are not set, getpos returns {0, 0, 0, 0}
  -- We check if the line number (lnum) is 0 to determine if a selection exists.
  if start_pos[2] == 0 or end_pos[2] == 0 then
    return nil
  end

  -- vim.fn.getregion is designed to work directly with the output of getpos.
  -- We also use vim.fn.visualmode() to get the type of the last selection (v, V, or CTRL-V).
  -- This is more reliable than checking the current mode.
  local lines = vim.fn.getregion(start_pos, end_pos, { type = vim.fn.visualmode() })

  local text = table.concat(lines, "\n")

  -- We return the original 1-indexed positions from getpos().
  -- The calling function will handle the conversion to 0-indexed if needed.
  return {
    text = text,
    start_pos = { line = start_pos[2], col = start_pos[3] },
    end_pos = { line = end_pos[2], col = end_pos[3] },
  }
end

-- Link utilities
M.link = {}

-- Create link patterns for reference updates
function M.link.create_patterns(old_date, new_filename_without_ext)
  local old_pattern = "[[" .. old_date .. "]]"
  local new_pattern = "[[" .. new_filename_without_ext .. "]]"
  return old_pattern, new_pattern
end

return M
