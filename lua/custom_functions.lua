local mkdn = require('mkdnflow')

local M = {}

function M.resethl()
    vim.cmd[[let @/='']]
end

function M.sleep(n)
  os.execute("sleep " .. tonumber(n))
end

function M.sleep_sec(a) 
    local sec = tonumber(os.clock() + a); 
    while (os.clock() < sec) do 
    end 
end

function M.textinsert(text)
  local pos = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  local nline = line:sub(1, pos + 1) .. text .. line:sub(pos + 2)
  vim.api.nvim_set_current_line(nline)
end

function M.ztltime()
    return os.date("%Y%m%d%H%M%S")
end

function M.linkwrap(text)
    return '[['..text..']]'
end

local function noteTemplate()
    text = [[
        # title
        tags: #
        - 
    ]]
    return text
end

function M.writefile(path, text)
    filewrite = io.open(path, "w")
    filewrite:write(text)
    filewrite:close()
end

function M.cleanline(line)
    local line = line:gsub(' *- ','')
    line = line:gsub('%s*$','')
    return line
end

function M.cleanHeadline(line)
    local line = line:gsub('# ','')
    line = line:gsub('%s*$','')
    return line
end

function M.currentNoteId()
    local ztl = vim.fn.getreg('%')
    _,_,id = ztl:find('([0-9]+)')
    return id
end

function M.backlinks()
    vim.fn.setreg('"', "'"..currentNoteId())
end

function M.aroundNote()
    local note = M.currentNoteId():sub(1,8) .. "*"
    vim.fn.setreg('+', note)
    return note
end

function M.delCurrentFile()
    vim.cmd[[call delete(expand('%')) | bdelete!]]
end

function M.currentLink()
    local path_to_file = vim.fn.getreg('%')
    local _,_,id = path_to_file:find('([0-9]+)')
    -- Opens a file in read mode
    local file = io.open(path_to_file, "r")
    -- prints the first line of the file
    local header = file:read()
    -- closes the opened file
    file:close()
    local link = M.cleanHeadline(header):lower() .. " [[" .. id .. "]]"
    vim.fn.setreg('+', link)
    return link
end

local note_template = "\ntag: N\n- "

function M.createID()
    local main_note = M.currentLink()
    local ztl = M.ztltime()
    local file_path = "/home/qq/Documents/i/" .. ztl .. ".md"
    local line = vim.api.nvim_get_current_line()
    line = M.cleanline(line)
    local text = '# ' .. line .. note_template .. '\n\n' .. main_note
    -- можно использовать для этого nvim.api.nvim_put()
    M.writefile(file_path, text)
    M.textinsert(M.linkwrap(ztl))
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_win_set_cursor(0, {pos[1],pos[2]+1})
    mkdn.links.followLink()
end

return M
