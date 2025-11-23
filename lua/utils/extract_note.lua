local M = {}

function M.extract_note_from_cursor()
  -- Require lumd when function is called, not at module load time
  local ok, lumd = pcall(require, "lumd")
  if not ok then
    vim.notify("lumd plugin not available", vim.log.levels.ERROR)
    return
  end

  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  
  -- Find the h1 line (either current line or search upward)
  local h1_line_num = nil
  for i = current_line, 1, -1 do
    if lines[i] and lines[i]:match("^# ") then
      h1_line_num = i
      break
    end
  end
  
  if not h1_line_num then
    vim.notify("No heading found above cursor", vim.log.levels.ERROR)
    return
  end
  
  local h1_line = lines[h1_line_num]
  
  -- Parse timestamp and title from h1 line
  -- Format: "# timestamp title"
  local timestamp, title = h1_line:match("^# (%S+)%s+(.+)")
  
  if not timestamp or not title then
    vim.notify("Invalid heading format. Expected: # timestamp title", vim.log.levels.ERROR)
    return
  end
  
  -- Find the next h1 line to determine content boundaries
  local next_h1_line = nil
  for i = h1_line_num + 1, #lines do
    if lines[i] and lines[i]:match("^# ") then
      next_h1_line = i
      break
    end
  end
  
  -- Extract content between current h1 and next h1 (or end of file)
  local content_start = h1_line_num + 1
  local content_end = next_h1_line and (next_h1_line - 1) or #lines
  
  local content_lines = {}
  for i = content_start, content_end do
    if lines[i] then
      table.insert(content_lines, lines[i])
    end
  end
  
  -- Remove trailing empty lines
  while #content_lines > 0 and content_lines[#content_lines]:match("^%s*$") do
    table.remove(content_lines)
  end
  
  local text = table.concat(content_lines, "\n")
  
  -- Call lumd.create_note with extracted data
  lumd.create_note({
    title = title,
    timestamp = timestamp,
    text = text
  })
end

return M
