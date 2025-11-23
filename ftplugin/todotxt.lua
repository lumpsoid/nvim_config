-- Map Enter key to insert date at start of new line
vim.keymap.set("i", "<CR>", function()
  local date = os.date("%Y-%m-%d")
  return "<CR>" .. date .. " "
end, { expr = true, buffer = true })

-- Map 'o' in normal mode to open line below with date
vim.keymap.set("n", "o", function()
  local date = os.date("%Y-%m-%d")
  return "o" .. date .. " "
end, { expr = true, buffer = true })

-- Map 'O' in normal mode to open line above with date
vim.keymap.set("n", "O", function()
  local date = os.date("%Y-%m-%d")
  return "O" .. date .. " "
end, { expr = true, buffer = true })

-- Function to toggle task completion or add a new task with date
vim.keymap.set("n", "td", function()
  local line = vim.fn.getline('.')
  local curr_line_num = vim.fn.line('.')

  -- Check if the line starts with 'x'
  if line:sub(1, 1) == "x" then
    -- Define a pattern to match two sequential dates with one whitespace
    local date_pattern = "(%d%d%d%d%-%d%d%-%d%d)%s+(%d%d%d%d%-%d%d%-%d%d)"

    -- Check for two sequential dates
    if line:match(date_pattern) then
      -- Remove 'x' and both dates
      local modified_line = line:gsub("^x %d%d%d%d%-%d%d%-%d%d%s+", "")
      modified_line = modified_line:gsub("^%s+", "") -- Trim leading whitespace
      vim.fn.setline(curr_line_num, modified_line)   -- Update the line
    else
      -- If there aren't two dates, just remove the 'x'
      local modified_line = line:gsub("^x%s*", "")
      vim.fn.setline(curr_line_num, modified_line) -- Update the line
    end
  else
    -- Prepend 'x YYYY-MM-DD' and keep the rest of the line
    local new_task = "x " .. os.date("%Y-%m-%d") .. " " .. line
    vim.fn.setline(curr_line_num, new_task) -- Set the new task
  end
end, { buffer = true })

-- Function to sort tasks by specified criteria while preserving original order for equal dates
vim.keymap.set("n", "ts", function()
  local lines = vim.fn.getline(1, '$') -- Get all lines in the file
  local completed_tasks = {}
  local incomplete_tasks = {}

  -- Helper function to extract dates from a task line
  local function get_task_dates(line)
    local task_date = line:match("%d%d%d%d%-%d%d%-%d%d")
    local done_date = line:match("x%s+(%d%d%d%d%-%d%d%-%d%d)")
    return task_date, done_date
  end

  -- Separate completed and incomplete tasks
  for i, line in ipairs(lines) do
    local task_date, done_date = get_task_dates(line)

    if line:sub(1, 1) == "x" then
      -- Completed task
      table.insert(completed_tasks, { line, task_date, done_date, i })
    else
      -- Incomplete task
      table.insert(incomplete_tasks, { line, task_date, i })
    end
  end

  -- Stable sorting completed tasks by done date, then by task date, using original index as a tie-breaker
  table.sort(completed_tasks, function(a, b)
    if a[3] and b[3] then
      -- Sort by done date if both have it
      if a[3] == b[3] then
        return a[4] < b[4] -- Keep original order if done dates are the same (using the index)
      end
      return a[3] > b[3]   -- Otherwise, sort by done date
    elseif a[3] then
      return true          -- a has a done date, b does not
    elseif b[3] then
      return false         -- b has a done date, a does not
    elseif a[2] and b[2] then
      -- If no done date, sort by task date
      if a[2] == b[2] then
        return a[4] < b[4] -- Keep original order if task dates are the same (using the index)
      end
      return a[2] > b[2]   -- Otherwise, sort by task date
    end
    return a[4] < b[4]     -- If neither has a date, use original index
  end)

  -- Stable sorting incomplete tasks by task date, using original index as a tie-breaker
  table.sort(incomplete_tasks, function(a, b)
    if a[2] and b[2] then
      -- Sort by task date if both have it
      if a[2] == b[2] then
        return a[4] < b[4] -- Keep original order if task dates are the same (using the index)
      end
      return a[2] > b[2]   -- Otherwise, sort by task date
    elseif a[2] then
      return true          -- a has a task date, b does not
    elseif b[2] then
      return false         -- b has a task date, a does not
    end
    return a[4] < b[4]     -- If neither has a date, use original index
  end)

  -- Combine sorted tasks
  local sorted_lines = {}
  for _, task in ipairs(incomplete_tasks) do
    table.insert(sorted_lines, task[1])
  end
  for _, task in ipairs(completed_tasks) do
    table.insert(sorted_lines, task[1])
  end

  -- Replace file content with sorted tasks
  vim.fn.setline(1, sorted_lines)
end, { buffer = true })
