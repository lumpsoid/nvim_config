local M = {}

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

--- Clear search highlighting
function M.resethl()
  vim.cmd [[let @/='']]
end

--- Sleep for n seconds (system call)
---@param n number seconds to sleep
function M.sleep(n)
  os.execute("sleep " .. tonumber(n))
end

--- Sleep for n seconds (busy wait)
---@param a number seconds to sleep
function M.sleep_sec(a)
  local sec = tonumber(os.clock() + a)
  while (os.clock() < sec) do
  end
end

--- Check if a file exists
---@param filename string path to file
---@return boolean
function M.fileExists(filename)
  local file, _ = io.open(filename, "r")
  if file then
    file:close()
    return true
  end
  return false
end

--- Write text to file
---@param path string file path
---@param text string content to write
function M.write_file(path, text)
  local filewrite = io.open(path, "w")
  if filewrite == nil then
    print(string.format('%s path is nil', path))
    return
  end
  filewrite:write(text)
  filewrite:close()
end

--- Get a specific line from a file
---@param filename string path to file
---@param line_number number line number to read
---@return string|nil
function M.getLine(filename, line_number)
  if M.fileExists(filename) then
    local line
    local n = line_number
    local f = io.open(filename, "r")
    if f == nil then
      return nil
    end
    for _ = 1, n do
      line = f:read()
    end
    f:close()
    return line
  end
  return nil
end

--- Get all files in current working directory
---@return table
function M.getFiles()
  local cwDir = vim.fn.getcwd()
  return vim.split(vim.fn.glob(cwDir .. "/*"), '\n', { trimempty = true })
end

-- ============================================================================
-- TEXT MANIPULATION FUNCTIONS
-- ============================================================================

--- Insert text at cursor position with smart spacing
---@param text string text to insert
function M.textInsert(text)
  local cursor_pos = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  local lineLength = string.len(line)
  local whitespacePre = " "
  local whitespacePost = " "
  local symbolPre = line:sub(cursor_pos, cursor_pos)
  local symbolPost = line:sub(cursor_pos + 1, cursor_pos + 1)

  if symbolPre == nil or symbolPre == " " then
    whitespacePre = ""
  end
  if symbolPost == nil or cursor_pos + 1 > lineLength or symbolPost == " " then
    whitespacePost = ""
  end

  local nline = line:sub(1, cursor_pos) .. whitespacePre .. text .. whitespacePost .. line:sub(cursor_pos + 1)
  vim.api.nvim_set_current_line(nline)
end

--- Clean line by removing markdown list prefix and trailing spaces
---@param line string line to clean
---@return string
function M.clean_line(line)
  local lineNew = line:gsub(' *- ', '')
  lineNew = lineNew:gsub('%s*$', '')
  return lineNew
end

--- Clean headline by removing markdown header prefix and trailing spaces
---@param line string headline to clean
---@return string
function M.cleanHeadline(line)
  local lineNew = line:gsub('# ', '')
  lineNew = lineNew:gsub('%s*$', '')
  return lineNew
end

--- Set text to system clipboard
---@param text string text to copy
local function setClipboard(text)
  vim.fn.setreg('+', text)
end

-- ============================================================================
-- LINK CREATION FUNCTIONS
-- ============================================================================

--- Create a wiki-style link
---@param text string link text
---@return string
function M.create_wiki_link(text)
  return '[[' .. text .. ']]'
end

--- Create a markdown link
---@param text string link text
---@param link string URL or path
---@return string
function M.create_markdown_link(text, link)
  return string.format("[%s](%s)", text, link)
end

-- ============================================================================
-- NOTE ID AND PATH FUNCTIONS
-- ============================================================================

--- Generate timestamp for zettelkasten
---@return string
function M.zettelstamp()
  return os.date("%Y%m%d%H%M%S")
end

--- Get current note ID from filename
---@return string
function M.currentNoteId()
  local path_to_file = vim.api.nvim_buf_get_name(0)
  local id = vim.fn.fnamemodify(path_to_file, ":t:r")
  return id
end

--- Extract date from note ID
---@param noteId string note identifier
---@return string
function M.todayFromNoteId(noteId)
  return noteId:sub(1, 8)
end

--- Get path to current file's directory
---@return string
function M.pathToCurrentFolder()
  return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
end

--- Create file path in current directory
---@param fileName string filename
---@return string
function M.create_file_path(fileName)
  local system = jit.os
  local currentFolder = M.pathToCurrentFolder()
  if system == "Windows" then
    return currentFolder .. '\\' .. fileName
  elseif system == "Linux" then
    return currentFolder .. '/' .. fileName
  end
end

-- ============================================================================
-- NOTE LINKING AND NAVIGATION FUNCTIONS
-- ============================================================================

--- Copy current note ID to default register (for backlinks)
function M.backlinks()
  vim.fn.setreg('"', "'" .. M.currentNoteId())
end

--- Generate pattern for notes around current date
---@return string
function M.aroundNote()
  local note = M.currentNoteId()
  note = string.gsub(note, '_', '')
  note = note:sub(1, 8) .. "*"
  vim.fn.setreg('+', note)
  return note
end

--- Get current note link with title
---@return string
function M.current_link()
  local path_to_file = vim.api.nvim_buf_get_name(0)
  local id = vim.fn.fnamemodify(path_to_file, ":t:r")

  local file = io.open(path_to_file, "r")
  if file == nil then
    return ""
  end

  local header = file:read()
  file:close()
  local link = M.create_wiki_link(id) .. " " .. M.cleanHeadline(header):lower()
  setClipboard(link)
  return link
end

--- Alias for current_link (maintaining backward compatibility)
function M.currentLink()
  return M.current_link()
end

-- ============================================================================
-- FILE OPERATIONS
-- ============================================================================

--- Delete current file with confirmation
function M.delCurrentFile()
  vim.ui.select({ 'yes', 'no' }, {
    prompt = 'Delete current file? This cannot be undone:',
  }, function(choice)
    if choice == 'yes' then
      vim.cmd [[call delete(expand('%')) | bdelete!]]
    end
  end)
end

-- ============================================================================
-- NOTE CREATION FUNCTIONS
-- ============================================================================

local note_template = "\n#N\n- \n\n## Backlinks\n- "

--- Create new note with UI input
function M.new_note()
  local new_note_header
  vim.ui.input(
    { prompt = 'Enter new note header: ' },
    function(input)
      new_note_header = input
    end
  )

  if new_note_header == '' or new_note_header == nil then
    return
  end

  local parent_note = M.current_link()
  local ztl = M.zettelstamp()
  local filename = ztl .. '.md'
  local file_path = M.create_file_path(filename)
  local new_note_text = '# ' .. new_note_header .. note_template .. parent_note

  M.write_file(file_path, new_note_text)
  local new_note_link = M.create_markdown_link(new_note_header, './' .. filename)
  M.textInsert(new_note_link)
end

--- Create note from current line content
function M.createID()
  local main_note = M.current_link()
  local ztl = M.zettelstamp()
  local pos = vim.api.nvim_win_get_cursor(0)
  local currentLine = vim.api.nvim_get_current_line()

  local file_path = M.create_file_path(ztl .. ".md")
  local new_header = M.clean_line(currentLine)
  local text = '# ' .. new_header .. note_template .. main_note

  M.write_file(file_path, text)

  -- Update current line with wiki link
  local linePrefix, lineText = string.match(currentLine, "^(%s*-%s)(.*)$")
  local newLine = linePrefix .. M.create_wiki_link(ztl) .. " " .. lineText
  vim.api.nvim_set_current_line(newLine)

  local prefixLength = string.len(linePrefix)
  vim.api.nvim_win_set_cursor(0, { pos[1], prefixLength + 2 })
  --mkdn.links.followLink()
end

-- ============================================================================
-- JOURNAL FUNCTIONS
-- ============================================================================

local daysOfWeek = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" }

--- Get date data with optional day shift
---@param shift number|nil days to shift (default: 0)
---@return table
function M.dateData(shift)
  shift = shift or 0
  local currentDate = os.date("*t")
  currentDate.day = currentDate.day + shift
  local dayOfWeek = daysOfWeek[currentDate.wday]

  return {
    year = currentDate.year,
    month = currentDate.month,
    day = currentDate.day,
    weekDay = dayOfWeek
  }
end

--- Open journal for today or shifted date
---@param shift number|nil days to shift (default: 0)
function M.openJournal(shift)
  shift = shift or 0
  local date = M.dateData(shift)
  local formattedFileName = string.format("%d_%02d_%02d.md", date.year, date.month, date.day)
  local formattedHeader = string.format("%d %02d %02d %s", date.year, date.month, date.day, date.weekDay)
  local filepath = M.create_file_path(formattedFileName)

  if not M.fileExists(filepath) then
    local fileTemplate = "# " .. formattedHeader .. "\n#daily\n- "
    M.write_file(filepath, fileTemplate)
  end

  vim.api.nvim_command("edit " .. filepath)
end

--- Open journal with shift from current journal file
---@param shift number days to shift
function M.openJournalShift(shift)
  local path_to_file = vim.api.nvim_buf_get_name(0)
  local currentFile = vim.fn.fnamemodify(path_to_file, ":t:r")
  local year, month, day = string.match(currentFile, "^([0-9]*)_([0-9]*)_([0-9]*)$")

  if not year then
    local currentDate = M.dateData()
    year = currentDate.year
    month = currentDate.month
    day = currentDate.day
  end

  year = tonumber(year)
  month = tonumber(month)
  day = tonumber(day) + shift

  local previousDate = os.date("*t", os.time({ year = year, month = month, day = day }))
  local dayOfWeek = daysOfWeek[previousDate.wday]
  local formattedFileName = string.format("%d_%02d_%02d.md", previousDate.year, previousDate.month, previousDate.day)
  local formattedHeader = string.format("%d %02d %02d %s", previousDate.year, previousDate.month, previousDate.day,
    dayOfWeek)
  local filepath = M.create_file_path(formattedFileName)

  if not M.fileExists(filepath) then
    local fileTemplate = "# " .. formattedHeader .. "\n#daily\n- "
    M.write_file(filepath, fileTemplate)
  end

  vim.api.nvim_command("edit " .. filepath)
end

--- Open journal for same date pattern as current file
function M.openJournalSameDay()
  local path_to_file = vim.api.nvim_buf_get_name(0)
  local currentFile = vim.fn.fnamemodify(path_to_file, ":t:r")
  local year = string.sub(currentFile, 1, 4)
  local month = string.sub(currentFile, 5, 6)
  local day = string.sub(currentFile, 7, 8)

  local formattedFileName = ""
  if year and month and day then
    formattedFileName = string.format("%s_%s_%s.md", year, month, day)
  else
    print("Date pattern not found in the file name.")
    return
  end

  local filepath = M.create_file_path(formattedFileName)
  vim.api.nvim_command("edit " .. filepath)
end

-- ============================================================================
-- TAG MANAGEMENT FUNCTIONS
-- ============================================================================

--- Check if line is a tag line (starts with #)
---@param line string line to check
---@return boolean
function M.isTagLine(line)
  local firstSimbol = string.sub(line, 1, 1)
  return firstSimbol == "#"
end

--- Collect all unique tags from files in directory
---@return table
function M.collectTags()
  local uniqueSet = {}
  local uniqueTags = {}
  table.insert(uniqueTags, os.time())
  local dirFiles = M.getFiles()

  for _, filePath in pairs(dirFiles) do
    local tagLine = M.getLine(filePath, 2)
    if tagLine ~= nil and M.isTagLine(tagLine) then
      for word in tagLine:gmatch("%S+") do
        if not uniqueSet[word] then
          table.insert(uniqueTags, word)
          uniqueSet[word] = true
        end
      end
    end
  end

  return uniqueTags
end

--- Index tags to cache file (updates every 5 minutes)
function M.indexTags()
  local filename = "./.tags_index"
  local cacheTime = nil

  if M.fileExists(filename) then
    local f = io.open(filename)
    if f ~= nil then
      cacheTime = f:read()
      if cacheTime ~= nil then
        local currentTime = os.time()
        local difTime = os.difftime(currentTime, cacheTime)
        if difTime / 60 <= 5 then
          return -- Cache is still fresh
        end
      end
      f:close()
    end
  end

  local tags = M.collectTags()
  local tagString = table.concat(tags, "\n")
  M.write_file(filename, tagString)
end

return M
