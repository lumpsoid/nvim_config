local mkdn = require('mkdnflow')

local M = {}

function M.resethl()
  vim.cmd [[let @/='']]
end

function M.sleep(n)
  os.execute("sleep " .. tonumber(n))
end

function M.sleep_sec(a)
  local sec = tonumber(os.clock() + a);
  while (os.clock() < sec) do
  end
end

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

function M.zettelstamp()
  return os.date("%Y%m%d%H%M%S")
end

function M.linkwrap(text)
  return '[[' .. text .. ']]'
end

function M.writeFile(path, text)
  local filewrite = io.open(path, "w")
  if filewrite == nil then
    print(string.format('%s path is nil', path))
    return
  end
  filewrite:write(text)
  filewrite:close()
end

---comment
---@param line string
---@return string
function M.cleanline(line)
  local lineNew = line:gsub(' *- ', '')
  lineNew = lineNew:gsub('%s*$', '')
  return lineNew
end

---comment
---@param line string
---@return string
function M.cleanHeadline(line)
  local lineNew = line:gsub('# ', '')
  lineNew = lineNew:gsub('%s*$', '')
  return lineNew
end

---comment
---@return string
function M.currentNoteId()
  local path_to_file = vim.api.nvim_buf_get_name(0)
  local id = vim.fn.fnamemodify(path_to_file, ":t:r")
  return id
end

---comment
---@param noteId string
function M.todayFromNoteId(noteId)
  return noteId:sub(1, 8)
end

function M.backlinks()
  vim.fn.setreg('"', "'" .. M.currentNoteId())
end

---comment
---@return string
function M.aroundNote()
  local note = M.currentNoteId()
  note = string.gsub(note, '_', '')
  note = note:sub(1, 8) .. "*"
  vim.fn.setreg('+', note)
  return note
end

function M.delCurrentFile()
  vim.ui.select({ 'yes', 'no' }, {
    prompt = 'Select Yes or No:',
  }, function(choice)
    if choice == 'yes' then
      vim.cmd [[call delete(expand('%')) | bdelete!]]
    end
  end)
end

function M.currentLink()
  local path_to_file = vim.api.nvim_buf_get_name(0)
  local id = vim.fn.fnamemodify(path_to_file, ":t:r")
  -- Opens a file in read mode
  local file = io.open(path_to_file, "r")
  -- prints the first line of the file
  local header = file:read()
  file:close()

  local link = "[[" .. id .. "]] " .. M.cleanHeadline(header):lower()
  vim.fn.setreg('+', link)
  return link
end

local note_template = "\n#N\n- \n- "

function M.pathToCurrentFolder()
  return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
end

function M.createFilePath(fileName)
  local system = jit.os
  local currentFolder = M.pathToCurrentFolder()
  if system == "Windows" then
    return currentFolder .. '\\' .. fileName
  elseif system == "Linux" then
    return currentFolder .. '/' .. fileName
  end
end

function M.createID()
  local main_note = M.currentLink()
  local ztl = M.zettelstamp()
  local pos = vim.api.nvim_win_get_cursor(0)
  local currentLine = vim.api.nvim_get_current_line()
  -- dynamicly take current folder to create note in it
  local file_path = M.createFilePath(ztl .. ".md")
  local new_header = vim.api.nvim_get_current_line()
  new_header = M.cleanline(currentLine)
  local text = '# ' .. new_header .. note_template .. main_note
  -- можно использовать для этого nvim.api.nvim_put()
  M.writeFile(file_path, text)

  -- write link to the line
  local linePrefix, lineText = string.match(currentLine, "^(%s*-%s)(.*)$")
  local newLine = linePrefix .. M.linkwrap(ztl) .. " " .. lineText
  vim.api.nvim_set_current_line(newLine)

  local prefixLength = string.len(linePrefix)
  vim.api.nvim_win_set_cursor(0, { pos[1], prefixLength + 2 })
  mkdn.links.followLink()
end

function M.fileExists(filename)
  local file, err = io.open(filename, "r")
  if file then
    file:close()
    return true
  end
  return false
end

local daysOfWeek = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" }

function M.dateData(shift)
  shift = shift or 0
  -- Get the current date and time
  local currentDate = os.date("*t")
  currentDate.day = currentDate.day + shift
  local currentDate = os.date("*t", os.time(currentDate))
  -- Get the day of the week
  local dayOfWeek = daysOfWeek[currentDate.wday]

  return {
    year = currentDate.year,
    month = currentDate.month,
    day = currentDate.day,
    weekDay = dayOfWeek
  }
end

function M.openJournal(shift)
  -- default value of shift
  shift = shift or 0
  -- vault folder
  local date = M.dateData(shift)
  local formattedFileName = string.format("%d_%02d_%02d.md", date.year, date.month, date.day)
  local formattedHeader = string.format("%d %02d %02d %s", date.year, date.month, date.day, date.weekDay)
  local filepath = M.createFilePath(formattedFileName)

  if not M.fileExists(filepath) then
    local fileTemplate = "# " .. formattedHeader .. "\n#daily\n- "
    M.writeFile(filepath, fileTemplate)
  end

  vim.api.nvim_command("edit " .. filepath)
end

function M.openJournalShift(shift)
  local path_to_file = vim.api.nvim_buf_get_name(0)
  local currentFolder = vim.fn.fnamemodify(path_to_file, ":h")
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
  local filepath = M.createFilePath(formattedFileName)

  if not M.fileExists(filepath) then
    local fileTemplate = "# " .. formattedHeader .. "\n#daily\n- "
    M.writeFile(filepath, fileTemplate)
  end

  vim.api.nvim_command("edit " .. filepath)
end

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

  local filepath = M.createFilePath(formattedFileName)
  vim.api.nvim_command("edit " .. filepath)
end

function M.getFiles()
  local cwDir = vim.fn.getcwd()
  return vim.split(vim.fn.glob(cwDir .. "/*"), '\n', { trimempty = true })
end

---comment
---@param filename string
---@param line_number number
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
  return nil -- line not found
end


function M.isTagLine(line)
  local firstSimbol = string.sub(line, 1, 1)
  if firstSimbol == "#" then
    return true
  end
  return false
end

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
          return
        end
      end
      f:close()
    end
  end
  local tags = M.collectTags()
  local tagString = table.concat(tags, "\n")
  M.writeFile(filename, tagString)
end

return M
