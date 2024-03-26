local previewers = require("telescope.previewers")
local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local make_entry = require "telescope.make_entry"

local flatten = vim.tbl_flatten

local M = {}

function M.findAroundNote()
  local current_note = require("custom_functions").aroundNote()
  local opts = opts or {}
  pickers.new(opts, {
    prompt_title = "Around Note",
    previewer = previewers.vim_buffer_cat.new(opts),
    finder = finders.new_oneshot_job({"rg", "--files", "-g", current_note, "--sort=path"}, opts),
    sorter = conf.generic_sorter(opts),
  }):find()
end

function M.listOfNotes()
  local opts = opts or {}
  pickers.new(opts, {
    prompt_title = "List of Notes",
    previewer = previewers.vim_buffer_cat.new(opts),
    finder = finders.new_oneshot_job({"rg", "--files", "-g", "*.md", "--sortr=path"}, opts),
    sorter = conf.generic_sorter(opts),
  }):find()
end

function M.backlinksSearch()
    local note = require("custom_functions").currentNoteId()
    require('telescope.builtin').grep_string({search=note})
end

function M.insertId()
  local opts = opts or {}
  local vimgrep_arguments = opts.vimgrep_arguments or conf.vimgrep_arguments
  local search_dirs = opts.search_dirs
  local grep_open_files = opts.grep_open_files
  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()

  local live_grepper = finders.new_job(function(prompt)
    -- TODO: Probably could add some options for smart case and whatever else rg offers.

    if not prompt or prompt == "" then
      return nil
    end

    local search_list = {}

    if grep_open_files then
      search_list = filelist
    elseif search_dirs then
      search_list = search_dirs
    end

    return flatten { vimgrep_arguments, additional_args, "--", prompt, search_list }
  end, opts.entry_maker or make_entry.gen_from_vimgrep(opts), opts.max_results, opts.cwd)

  pickers
    .new(opts, {
      prompt_title = "Live Grep",
      finder = live_grepper,
      previewer = conf.grep_previewer(opts),
      sorter = sorters.highlighter_only(opts),
      --sorter = require("telescope").extensions.fzf.native_fzf_sorter({ case_mode = "smart_case", fuzzy = true }),
      --sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        map("i", "<c-space>", actions.to_fuzzy_refine)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          selection = "[[" .. selection.filename:sub(1,14) .. "]]"
          vim.api.nvim_put({ selection }, "", false, true)
        end)
        return true
      end,
    })
    :find()
end

--function M.testfuzzy()
--    opts = opts or {}
--    opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()
--    opts.entry_maker = opts.entry_maker or make_entry.gen_from_vimgrep(opts)
--      pickers.new(opts, {
--        prompt_title = "Test Fuzz",
--        previewer = conf.grep_previewer(opts),
--        finder = finders.new_job({"rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case"}, opts),
--        sorter = require("telescope").extensions.fzf.native_fzf_sorter({ case_mode = "smart_case", fuzzy = true }),
--      }):find()
--end

function M.insertLink()
  local opts = opts or {}
  local vimgrep_arguments = opts.vimgrep_arguments or conf.vimgrep_arguments
  local search_dirs = opts.search_dirs
  local grep_open_files = opts.grep_open_files
  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()

  local live_grepper = finders.new_job(function(prompt)
    -- TODO: Probably could add some options for smart case and whatever else rg offers.

    if not prompt or prompt == "" then
      return nil
    end

    local search_list = {}

    if grep_open_files then
      search_list = filelist
    elseif search_dirs then
      search_list = search_dirs
    end

    return flatten { vimgrep_arguments, additional_args, "--", prompt, search_list }
  end, opts.entry_maker or make_entry.gen_from_vimgrep(opts), opts.max_results, opts.cwd)

  pickers
    .new(opts, {
      prompt_title = "Live Grep",
      finder = live_grepper,
      previewer = conf.grep_previewer(opts),
      sorter = sorters.highlighter_only(opts),
      attach_mappings = function(prompt_bufnr, map)
        map("i", "<c-space>", actions.to_fuzzy_refine)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          --print(vim.inspect(selection))
          local path_to_file = getmetatable(selection).cwd .. "/" .. selection.filename
          -- Opens a file in read mode
          local file = io.open(path_to_file, "r")
          -- prints the first line of the file
          local header = file:read()
          -- closes the opened file
          file:close()
          local selection =  require("custom_functions").cleanHeadline(header):lower() .. " [[" .. selection.filename:sub(1,14) .. "]]"
          vim.api.nvim_put({ selection }, "", false, true)
        end)
        return true
      end,
     -- attach_mappings = function(_, map)
     --   map("i", "<c-space>", actions.to_fuzzy_refine)
     --   return true
     -- end,
    })
    :find()
end

return M
--function M.testf()
--    opts = {           
--      bufnr = 1,                 
--      winnr = 1000
--    } 
--    pickers.new ({
--
--          results_title = "Test",
--          -- Run an external command and show the results in the finder window
--          --finder = finders.new_oneshot_job({"ls", "-r"}),
--          finder = finders.new_table {
--            results = {'2022', '2021', '2020'},
--            entry_maker = false,
--          },
--          sorter = sorters.get_fzy_sorter(opts),
--          previewer = previewers.vim_buffer_cat.new(opts)
--    }):find()
--end
