local M = {}

-- replace the last visual selection with <text>
function M.replace_visual(text)
  local b = vim.fn.line("'<") - 1          -- 0-indexed start line
  local c = vim.fn.col("'<") - 1           -- 0-indexed start column
  local e = vim.fn.line("'>") - 1          -- 0-indexed end line
  local f = vim.fn.col("'>")               -- end column is *inclusive* → add 1 below

  -- nvim_buf_set_text expects {end_col} to be exclusive
  vim.api.nvim_buf_set_text(0, b, c, e, f, { text })
end

return M
