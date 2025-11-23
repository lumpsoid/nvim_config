local M = {}
local config = require("lumd.config")
local create = require("lumd.create")
local utils = require("lumd.utils")

-- Check if FzfLua is available
local function check_fzf_lua()
  local ok, fzf = pcall(require, "fzf-lua")
  if not ok then
    vim.notify("FzfLua is not installed. Please install it to use this feature.", vim.log.levels.ERROR)
    return nil
  end
  return fzf
end

-- Extract title from filename
local function extract_title_from_filename(filename)
  local name = filename:gsub("%.%w+$", "")
  local title = name:match("^%d+T%d+%-%-(.+)")
  if title then
    title = title:gsub("__.+$", "")
    title = title:gsub("-", " ")
  end
  return title or name
end

-- Extract tags from filename
local function extract_tags_from_filename(filename)
  local name = filename:gsub("%.%w+$", "")
  local tags_part = name:match("__(.+)$")
  if not tags_part then return {} end
  local tags = {}
  for tag in tags_part:gmatch("([^_]+)") do
    table.insert(tags, tag)
  end
  return tags
end

-- Get preview content for a note file
local function get_preview_content(filepath)
  local file = io.open(filepath, "r")
  if not file then return { "Could not read file" } end

  local lines = {}
  local preview_lines = config.get("modules.fzf.preview_lines") or 20
  for _ = 1, preview_lines do -- Read first N lines
    local line = file:read("*line")
    if not line then break end
    lines[#lines + 1] = line
  end
  file:close()

  return lines
end

-- Create link to selected file
local function create_link(filepath, title)
  local current_file = vim.fn.expand("%:p")                  -- Get full path of current file
  local current_dir = vim.fn.fnamemodify(current_file, ":h") -- Get directory of current file
  local relative_path = vim.fn.fnamemodify(filepath, ":p:.")
  
  -- Make it relative to current file's directory, not cwd
  if current_file ~= "" then
    -- Use vim's reltime-like calculation or manual path resolution
    local target_path = vim.fn.fnamemodify(filepath, ":p")
    -- This gives path relative to current file's directory
    relative_path = vim.fn.substitute(target_path, "^" .. vim.fn.escape(current_dir .. "/", "\\"), "", "")
  end
  
  local link = "[" .. title .. "]" .. "(" .. "./" .. relative_path .. ")"
  
  local pos = vim.api.nvim_win_get_cursor(0)
  local row, col = pos[1], pos[2]
  
  local line = vim.api.nvim_get_current_line()
  
  local new_line = line:sub(1, col) .. link .. line:sub(col + 1)
  
  vim.api.nvim_set_current_line(new_line)
  vim.api.nvim_win_set_cursor(0, { row, col + #link })
end

-- Prepare entries for fzf display
local function prepare_entries(files, create_new_text)
  local entries = {}
  -- Add create new option first
  table.insert(entries, {
    display = create_new_text or config.get("modules.fzf.create_new_text") or "📝 Create new note",
    filename = "CREATE_NEW",
    filepath = "CREATE_NEW",
    title = "Create new note",
    tags = {}
  })

  -- Add existing files
  for _, filepath in ipairs(files) do
    local filename = vim.fn.fnamemodify(filepath, ":t")
    -- Calculate relative path from current file's directory to target file
    local title = extract_title_from_filename(filename)
    table.insert(entries, {
      display = filename,
      filename = filename,
      filepath = filepath,
      title = title,
    })
  end
  return entries
end

-- Create custom previewer
local function create_custom_previewer(entries, preview_text)
  local builtin = require("fzf-lua.previewer.builtin")
  local CustomPreviewer = builtin.base:extend()
  
  function CustomPreviewer:new(o, opts, fzf_win)
    CustomPreviewer.super.new(self, o, opts, fzf_win)
    setmetatable(self, CustomPreviewer)
    return self
  end

  function CustomPreviewer:populate_preview_buf(entry_str)
    local tmpbuf = self:get_tmp_buffer()
    -- Find the corresponding entry
    local entry = nil
    for i, e in ipairs(entries) do
      if e.display == entry_str then
        entry = e
        break
      end
    end
    local content_lines = {}
    if entry and entry.filepath ~= "CREATE_NEW" then
      content_lines = get_preview_content(entry.filepath)
    else
      table.insert(content_lines, preview_text or "Create a new note")
    end
    vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, content_lines)
    self:set_preview_buf(tmpbuf)
    self.win:update_preview_scrollbar()
  end

  function CustomPreviewer:gen_winopts()
    local new_winopts = {
      wrap = true,
      number = false
    }
    return vim.tbl_extend("force", self.winopts, new_winopts)
  end

  return CustomPreviewer
end

-- Create fzf options
local function create_fzf_opts(entries, prompt, create_note_fn, preview_text)
  return {
    prompt = prompt,
    winopts = {
      height = 0.6,
      width = 0.8,
      preview = {
        layout = "horizontal",
        horizontal = "right:50%"
      }
    },
    fzf_opts = {
      ["--header"] = "Enter: Open file | Ctrl-L: Insert link | Ctrl-N: Create new",
      ["--preview-window"] = "right:50%:wrap",
    },
    previewer = create_custom_previewer(entries, preview_text),
    actions = {
      ["default"] = function(selected, opts)
        local entry = nil
        for i, e in ipairs(entries) do
          if e.display == selected[1] then
            entry = e
            break
          end
        end
        if entry and entry.filepath ~= "CREATE_NEW" then
          vim.cmd("edit " .. vim.fn.fnameescape(entry.filepath))
        elseif entry then
          create_note_fn()
        end
      end,
      ["ctrl-l"] = function(selected, opts)
        local entry = nil
        for i, e in ipairs(entries) do
          if e.display == selected[1] then
            entry = e
            break
          end
        end
        if entry and entry.filepath == "CREATE_NEW" then
          create_note_fn()
        elseif entry then
          create_link(entry.filepath, entry.title)
        end
      end,
      ["ctrl-n"] = function(selected, opts)
        local query = opts.query or ""
        create_note_fn({ title = query })
      end,
    }
  }
end

-- Main function to find or create notes
function M.find_or_create_note()
  local fzf = check_fzf_lua()
  if not fzf then return end

  local current_vault = config.get_current_vault()
  local notes_dir = current_vault.path
  local pattern = notes_dir .. "/**/*." .. config.get("file.extension")
  local files = vim.fn.glob(pattern, false, true)
  local entries = prepare_entries(files)
  local opts = create_fzf_opts(
    entries,
    "Notes> ",
    create.create_note,
    "Create a new note with the current line as title"
  )
  local display_entries = vim.tbl_map(function(entry) return entry.display end, entries)
  fzf.fzf_exec(display_entries, opts)
end

return M
