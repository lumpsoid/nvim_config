local M = {}

-- Detect operating system for external file opening
function M.get_open_command()
  if vim.fn.has("mac") == 1 then
    return "open"
  elseif vim.fn.has("unix") == 1 then
    return "xdg-open"
  elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    return "start"
  else
    error("Unsupported operating system")
  end
end

-- Check if file is a text file based on extension
function M.is_text_file(filepath)
  local text_extensions = {
    "txt", "md", "markdown", "rst", "org", "tex", "py", "js", "html", "css",
    "json", "xml", "yml", "yaml", "toml", "ini", "conf", "cfg", "log",
    "lua", "vim", "sh", "bash", "zsh", "fish", "c", "cpp", "h", "hpp",
    "java", "go", "rs", "rb", "php", "pl", "r", "sql", "csv"
  }
  
  local ext = filepath:match("%.([^%.]+)$")
  if not ext then return true end -- No extension, assume text
  
  ext = ext:lower()
  for _, text_ext in ipairs(text_extensions) do
    if ext == text_ext then
      return true
    end
  end
  
  return false
end

-- Check if string is a URL
function M.is_url(str)
  return str:match("^https?://") or str:match("^ftp://") or str:match("^ftps://")
end

-- Resolve relative path
function M.resolve_path(link)
  if link:match("^/") or link:match("^%a:") then
    -- Absolute path (Unix or Windows)
    return link
  elseif link:match("^~/") then
    -- Home directory
    return vim.fn.expand(link)
  else
    -- Relative path
    local current_file = vim.api.nvim_buf_get_name(0)
    local current_dir = vim.fn.fnamemodify(current_file, ":h")
    return vim.fn.resolve(current_dir .. "/" .. link)
  end
end

return M
