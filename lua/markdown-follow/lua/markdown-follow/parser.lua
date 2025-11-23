local config = require('markdown-follow.config')

local M = {}

-- Extract link under cursor
function M.get_link_under_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- Convert to 1-indexed
  
  -- Try markdown style [text](url)
  local markdown_pattern = "%[([^%]]+)%]%(([^%)]+)%)"
  for text, url in line:gmatch(markdown_pattern) do
    local start_pos = line:find("%[" .. text:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1") .. "%]%(")
    local end_pos = start_pos + text:len() + url:len() + 3 -- [](  )
    if col >= start_pos and col <= end_pos then
      return url
    end
  end
  
  -- Try wiki style [[link]]
  local wiki_pattern = "%[%[([^%]]+)%]%]"
  for url in line:gmatch(wiki_pattern) do
    local start_pos = line:find("%[%[" .. url:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1") .. "%]%]")
    local end_pos = start_pos + url:len() + 3 -- [[]]
    if col >= start_pos and col <= end_pos then
      -- Add extension if wiki link doesn't have one
      if not url:match("%.%w+$") then
        url = url .. "." .. config.options.wiki_extension
      end
      return url
    end
  end
  
  return nil
end

return M
