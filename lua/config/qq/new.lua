local new = require('qq.new')
local time = require('qq.time')
local buffer = require('qq.buffer')

local M = {}


-- helper: turn any string into a safe file name
local function sanitise_name(s)
  return s:lower()
      :gsub('%s+', '-')         -- spaces → dash
      :gsub('[^%w%-_]', '')     -- strip weird chars
      :gsub('%-+', '-')         -- collapse multiple dashes
      :gsub('^%-*', '')         -- no leading dash
      :gsub('%-*$', '')         -- no trailing dash
end

function M.createNote()
  new.create({
    open_before_post_create = false,
    open_after_post_create = true,
    pre_create = function(ctx)
      local proposed        = ctx.visual_selection or ''
      local ans             = vim.fn.input('Create file: ', proposed, 'file')
      ctx.filename_response = ans
      ctx.parent_filename   = vim.api.nvim_buf_get_name(0)
      return ans ~= '' and ans or nil
    end,
    file_name = function(ctx)
      ctx.filename = sanitise_name(ctx.filename_response)
      ctx.basename = ctx.filename .. '.md'
      return ctx.basename
    end,
    template = function(ctx)
      local title = ctx.filename_response
      local date = time.isoTimestamp()
      local backlink = ctx.visual_selection and '[[' .. vim.fn.fnamemodify(ctx.parent_filename, ':t:r') .. ']]' or ''
      return {
        '# ' .. title,
        '#tags',
        date,
        '',
        '',
        '',
        '## Backlinks',
        '',
        backlink
      }
    end,
    post_create = function(ctx)
      if ctx.visual_selection then
        local link = '[[' .. ctx.filename .. ']]'
        buffer.replace_visual(link)
      end
    end
  })
end

return M
