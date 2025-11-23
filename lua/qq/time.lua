local M = {}
-- current offset in seconds (positive if local is ahead of UTC)
local function tzOffset()
  local utc = os.time(os.date("!*t"))
  local loc = os.time(os.date("*t"))
  return loc - utc
end

-- convert offset seconds to ±HH:MM string
local function offsetString(sec)
  local sign = sec < 0 and '-' or '+'
  sec = math.abs(sec)
  local h = math.floor(sec / 3600)
  local m = math.floor((sec % 3600) / 60)
  return string.format('%s%02u:%02u', sign, h, m)
end

-- ISO-8601 time stamp with zone offset
function M.isoTimestamp()
  local t = os.date("*t")
  local iso = string.format('%04u-%02u-%02u %02u:%02u:%02u',
                            t.year, t.month, t.day, t.hour, t.min, t.sec)
  return iso .. offsetString(tzOffset())
end

return M
