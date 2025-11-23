local M = {}

local lib = {}

lib.templates = {
  mod = function(_)
    return { 'local M = {}', '', 'function M.setup(opts)', '  -- TODO', 'end', '', 'return M' }
  end,

  scratch = { '-- scratch', 'print("hello")' },

  plugin = function(_)
    return {
      'local M = {}',
      '',
      'function M.setup(opts)',
      '  -- TODO',
      'end',
      '',
      'return M',
    }
  end,
  note = function(ctx)
    local name = vim.fn.fnamemodify(ctx.file_name_result, ':t:r')
    local date = require('qq.time').isoTimestamp()
    return {
      '# ' .. name,
      '',
      date,
      '',
    }
  end,
}

lib.presets = {
  mod = {
    pre_create  = function(ctx)
      local guess = (ctx.variant or 'untitled') .. '.lua'
      local ans   = vim.fn.input('Create file: ', guess, 'file')
      return ans ~= '' and ans or nil
    end,
    file_name   = function(ctx) return ctx.pre_create_result end,
    template    = 'mod',
    open_before_post_create = true,
    post_create = function(_) vim.cmd 'normal! G$o' end,
  },

  plugin = {
    pre_create  = function(ctx)
      local guess = 'lua/' .. (ctx.variant or 'plugin') .. '/' .. (ctx.variant or 'plugin') .. '.lua'
      local ans   = vim.fn.input('Create plugin: ', guess, 'file')
      return ans ~= '' and ans or nil
    end,
    file_name   = function(ctx) return ctx.pre_create_result end,
    template    = 'plugin',
    post_create = function(_) vim.cmd 'normal! gg$' end,
  },
}

lib.callbacks = {
  -- ask user for a file name, default = variant .. '.lua'
  ask_file = function(ctx)
    local guess = (ctx.variant or 'untitled') .. '.lua'
    local ans   = vim.fn.input('Create file: ', guess, 'file')
    return ans ~= '' and ans or nil
  end,

  -- ask for a plugin path under lua/
  ask_plugin = function(ctx)
    local name = ctx.variant or 'plugin'
    local guess = ('lua/%s/%s.lua'):format(name, name)
    local ans = vim.fn.input('Create plugin: ', guess, 'file')
    return ans ~= '' and ans or nil
  end,

  -- jump to last line, open a new line, enter insert-mode
  insert_end = function(_)
    vim.cmd 'normal! G$o'
  end,

  -- jump to first line, last column
  top_col = function(_)
    vim.cmd 'normal! gg$'
  end,

  -- Return the visual selection (or nil)
  get_visual = function(ctx)
    return ctx.visual_selection
  end,
}

local function ensure_callback_fn(cb, lib_cb)
  if type(cb) == 'function' then return cb end
  if type(cb) == 'string' then
    local fn = lib_cb[cb]
    if not fn then error('unknown callback: ' .. cb) end
    return fn
  end
  error 'callback must be a function or a string name'
end

function M.visual_selection()
  local ls, cs = vim.fn.line "'<", vim.fn.col "'<"
  local le, ce = vim.fn.line "'>", vim.fn.col "'>"
  local lines  = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)
  if #lines == 0 then return nil end
  lines[#lines] = lines[#lines]:sub(1, ce)
  lines[1]      = lines[1]:sub(cs)
  return table.concat(lines, '\n')
end

local function ensure_template_fn(tmpl)
  if type(tmpl) == 'function' then return tmpl end
  if type(tmpl) == 'table' then return function(_) return tmpl end end
  error 'template must be a function or a list of strings'
end

local function build(opts)
  opts          = opts or {}
  local variant = opts.variant or 'mod'

  local base    = lib.presets[variant] or lib.presets.mod
  local cfg     = vim.tbl_deep_extend('force', base, opts)

  -- resolve template
  local tmpl    = cfg.template
  if type(tmpl) == 'string' then
    tmpl = lib.templates[tmpl] or error('unknown template: ' .. tmpl)
  end
  cfg.template    = ensure_template_fn(tmpl)

  -- resolve callbacks
  cfg.pre_create  = ensure_callback_fn(cfg.pre_create or lib.callbacks.ask_file, lib.callbacks)
  cfg.file_name   = ensure_callback_fn(cfg.file_name or function(ctx) return ctx.pre_create_result end, lib.callbacks)
  cfg.post_create = ensure_callback_fn(cfg.post_create or function() end, lib.callbacks)

  return cfg
end


function M.create(opts)
  local ctx = build(opts)

  ctx.visual_selection = M.visual_selection()

  -- 1. pre-create
  ctx.pre_create_result = ctx.pre_create(ctx)
  if not ctx.pre_create_result then return end

  -- 2. file name
  ctx.file_name_result = ctx.file_name(ctx)
  if not ctx.file_name_result then return end -- still respect manual abort

  if vim.fn.filereadable(ctx.file_name_result) == 1 then
    vim.notify('File already exists: ' .. ctx.file_name_result, vim.log.levels.WARN)
    return
  end

  -- 3. template
  local lines = ctx.template(ctx)

  -- 4. write & open
  vim.fn.mkdir(vim.fn.fnamemodify(ctx.file_name_result, ':h'), 'p')
  vim.fn.writefile(lines, ctx.file_name_result)

  if ctx.open_before_post_create then
    vim.cmd('edit ' .. ctx.file_name_result)
    ctx.buffer = vim.api.nvim_get_current_buf()
  end

  -- 5. post-create
  ctx.post_create(ctx)

  if ctx.open_after_post_create then
    vim.cmd('edit ' .. ctx.file_name_result)
    ctx.buffer = vim.api.nvim_get_current_buf()
  end
end

function M.setup(user)
  if not user then return end
  if user.templates then
    for k, v in pairs(user.templates) do lib.templates[k] = v end
  end
  if user.variants then
    for k, v in pairs(user.variants) do lib.presets[k] = v end
  end
end

vim.api.nvim_create_user_command('NewFile', function(cmd)
  local variant = cmd.args ~= '' and cmd.args or nil
  local ok, err = pcall(M.create, variant, { visual_selection = cmd.range > 0 and visual_selection() or nil })
  if not ok then vim.notify(err, vim.log.levels.ERROR) end
end, { nargs = '?', range = true })

---------------------------------------------------------------
-- 6.  METATABLE  (module is callable)
---------------------------------------------------------------
setmetatable(M, { __call = function(_, ...) return M.create(...) end })

return M
