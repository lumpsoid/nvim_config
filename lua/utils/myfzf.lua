local M = {}

local lib = {}

-- 1-a.  POPULATORS  (must return list of absolute paths) --
lib.populators = {
  cwd_files = function()
    return vim.fn.glob(vim.loop.cwd() .. '/*', false, true)
  end,

  md_files = function()
    local all = lib.populators.cwd_files()
    return vim.tbl_filter(function(f) return f:match('%.md$') end, all)
  end,

  git_files = function()
    return require('fzf-lua.utils').git_ls()
  end,

  backlinks = function() -- needs current note id
    local note = require('cf').currentNoteId()
    return { cmd = 'rg --json ' .. vim.fn.shellescape(note), }
  end,

  aroundNote = function()
    local cf      = require('cf')
    local noteId  = cf.currentNoteId():gsub('_', '')
    local y, m, d = cf.todayFromNoteId(noteId):match('^(....)(..)(..)')
    local pattern = ('%s_?%s_?%s.*%.md'):format(y, m, d)
    return { cmd = ('rg --files | rg -e %s | sort -r'):format(pattern) }
  end,

  allMd = function()
    return { cmd = 'rg --files -g *.md | sort -r' }
  end,

  journalMd = function()
    return { cmd = 'rg --files -g *_*_*.md | sort -r' }
  end,

  tagIndex = function()
    return { cmd = 'cat .tags_index 2>/dev/null' }
  end,
}

-- 1-b.  FORMATTERS  (path -> string shown in fzf) --------
lib.formatters = {
  basename = function(path)
    return vim.fn.fnamemodify(path, ':t')
  end,

  title = function(path, pattern)
    -- skip directories
    local stat = vim.loop.fs_stat(path)
    if not stat or stat.type == 'directory' then
      return ('%s │ %s'):format(path, 'dir')
    end

    local name = vim.fn.fnamemodify(path, ':t')
    if pattern and not name:match(pattern) then return name end

    local fh = io.open(path)
    if not fh then return name end

    for line in fh:lines() do
      if line:find '%S' then
        fh:close()
        return ('%-30s │ %s'):format(name, line:sub(1, 50))
      end
    end
    fh:close()
    return name
  end,

  live_grep_line = function(_, line) -- for live_grep the arg is the raw line
    return line
  end,
}

-- 1-c.  ACTIONS  (what happens on key press) -------------
lib.actions = {
  open         = function(paths)
    require('fzf-lua.actions').file_edit(paths, {})
  end,
  tabedit      = function(paths)
    require('fzf-lua.actions').file_tabedit(paths, {})
  end,
  rename       = function(paths)
    local old = paths[1]
    local new = vim.fn.input('Rename → ', old, 'file')
    if new and new ~= '' and new ~= old then
      vim.loop.fs_rename(old, new)
      vim.notify(('Renamed: %s → %s'):format(old, new), vim.log.levels.INFO)
    end
  end,
  delete       = function(paths)
    local path = paths[1]
    local ans = vim.fn.input(('Delete %s ? y/N '):format(path))
    if ans:lower() == 'y' then
      vim.loop.fs_unlink(path)
      vim.notify('Deleted: ' .. path, vim.log.levels.WARN)
    end
  end,

  insertHeadId = function(paths)
    local cf   = require('cf')
    local file = paths[1]:match('[0-9].*%.md') or paths[1]
    local fh   = io.open(file)
    if not fh then return end
    local header = fh:read()
    fh:close()
    local id = '[[' .. vim.fn.fnamemodify(file, ':t:r') .. ']]'
    cf.textInsert(id .. ' ' .. cf.cleanHeadline(header):lower())
  end,

  insertId     = function(paths)
    local file = paths[1]:match('[0-9].*%.md') or paths[1]
    local id   = '[[' .. vim.fn.fnamemodify(file, ':t:r') .. ']]'
    require('cf').textInsert(id)
  end,

  insertTag    = function(_, lines) -- second param is what fzf gave us
    local tags = vim.tbl_map(function(l) return l:match('#.*') or l end, lines)
    vim.api.nvim_put({ table.concat(tags, ' ') }, '', true, true)
  end,
}

-- 1-d.  KEYMAPS  -----------------------------------------
lib.keymaps = {
  default = {
    ['enter']  = 'open',
    ['ctrl-t'] = 'tabedit',
    ['ctrl-r'] = 'rename',
    ['ctrl-d'] = 'delete',
  },
}

-----------------------------------------------------------
-- 2.  DEFAULT CONFIG  (used by generic picker)
-----------------------------------------------------------
local default = {
  populator = lib.populators.cwd_files,
  formatter = function(path)
    return lib.formatters.title(path, '.')
  end,
  actions   = lib.actions,
  keymap    = lib.keymaps.default,
  prompt    = 'Fzf> ',
}

-----------------------------------------------------------
-- 3.  INTERNAL BUILDER
-----------------------------------------------------------
local function build(opts)
  opts             = vim.tbl_deep_extend('force', default, opts or {})

  local populator  = type(opts.populator) == 'string'
      and lib.populators[opts.populator] or opts.populator
  local formatter  = type(opts.formatter) == 'string'
      and lib.formatters[opts.formatter] or opts.formatter
  local actions    = opts.actions
  local keymap     = opts.keymap

  ------------------------------------------------------------------
  local pop_result = (type(populator) == "function" and populator()) or populator
  local cmd, lines, display_to_path
  if type(pop_result) == 'table' and pop_result.cmd then
    -- command will be executed by fzf-lua itself
    cmd             = pop_result.cmd
    lines           = nil
    display_to_path = nil -- <<-  important
  else
    -- we already have a list of paths
    cmd             = nil
    lines           = vim.tbl_map(function(p) return formatter(p) end, pop_result)
    -- build mapping only here
    display_to_path = {}
    for i, path in ipairs(pop_result) do
      display_to_path[lines[i]] = path
    end
  end

  ------------------------------------------------------------------
  -- wrap actions: translate *only* when we have a mapping
  local wrapped_actions = {}
  for k, act in pairs(keymap) do
    wrapped_actions[k] = function(selected)
      -- resolve string → function
      local fn = type(act) == 'string' and actions[act] or act
      -- selected is *always* the table that fzf-lua gives us
      fn(selected)
    end
  end

  return {
    cmd     = cmd,
    lines   = lines,
    actions = wrapped_actions,
    prompt  = opts.prompt,
  }
end

-----------------------------------------------------------
-- 4.  GENERIC PICKER  (unchanged)
-----------------------------------------------------------
function M.picker(opts)
  local data = build(opts)
  if data.cmd then
    -- commands that produce the list themselves
    require('fzf-lua').files({
      cmd     = data.cmd,
      prompt  = data.prompt,
      actions = data.actions,
    })
  else
    -- we already built the list
    require('fzf-lua').fzf_exec(data.lines, {
      prompt  = data.prompt,
      actions = data.actions,
    })
  end
end

-----------------------------------------------------------
-- 5.  PRE-BAKED VARIANTS  (your old functions ported)
-----------------------------------------------------------

-- helper: shared preview / window opts used by almost every variant
local PREVIEW_OPTS = {
  fzf_cli_args = '--preview-window=~1',
  fzf_opts     = { ['--tiebreak'] = 'length,begin' },
  previewer    = 'bat',
  keymap       = {
    fzf = {
      ['shift-down'] = 'preview-half-page-down',
      ['shift-up']   = 'preview-half-page-up',
    }
  },
  winopts      = { preview = { horizontal = 'down:60%' } },
}

-- tiny wrappers that just call the generic picker with the right mix
function M.backlinks() M.picker { populator = 'backlinks', formatter = 'live_grep_line', prompt = 'Back> ' } end

function M.findAroundNote() M.picker { populator = 'aroundNote', formatter = 'basename', prompt = 'Around> ' } end

function M.listOfNotes() M.picker { populator = 'allMd', formatter = 'basename', prompt = 'Notes> ' } end

function M.journalList() M.picker { populator = 'journalMd', formatter = 'basename', prompt = 'Journal> ' } end

function M.insertHeadId() M.picker { populator = 'allMd', formatter = 'basename', prompt = 'HeadId> ', keymap = { enter = 'insertHeadId' } } end

function M.insertId() M.picker { populator = 'allMd', formatter = 'basename', prompt = 'Id> ', keymap = { enter = 'insertId' } } end

function M.insertTag() M.picker { populator = 'tagIndex', formatter = 'live_grep_line', prompt = 'Tag> ', keymap = { enter = 'insertTag' }, fzf_opts = { ['--multi'] = true } } end

function M.openFile() M.picker { populator = { cmd = 'rg --files' }, formatter = 'title', prompt = 'Open> ' } end

-----------------------------------------------------------
-- 6.  EXPOSE LIBRARY FOR RUN-TIME EXTENSIONS
-----------------------------------------------------------
M.lib = lib
setmetatable(M, { __call = function(_, opts) return M.picker(opts) end })

return M
