local settings = require("settings")
local colors = require("colors")

local function numbers_font(size)
  return {
    family = settings.font.numbers,
    style = settings.font.style_map["Regular"],
    size = size or 12.0,
  }
end

local function piece(name, color, padding_right, string)
  return sbar.add("item", name, {
    position = "right",
    icon = { drawing = false },
    label = {
      string = string or "",
      color = color,
      padding_left = 0,
      padding_right = 0,
      font = numbers_font(),
    },
    background = { drawing = false },
    padding_left = 0,
    padding_right = padding_right or 0,
    click_script = "open -a 'Calendar'",
  })
end

local quarter_left = piece("date.quarter_left", colors.dim, 6)
local quarter = piece("date.quarter", colors.grey, 2)
local date_month = piece("date.month", colors.grey, 6)
local date_sep = piece("date.sep", colors.dim, 0, "/")
local date_day = piece("date.day", colors.accent, 0)
local clock = piece("clock", colors.accent, 6)

clock:set({ update_freq = 30 })

local function quarter_end(now)
  local t = os.date("*t", now)
  local q = math.ceil(t.month / 3)
  local last_month = q * 3
  local next_quarter = os.time({
    year = last_month == 12 and t.year + 1 or t.year,
    month = last_month == 12 and 1 or last_month + 1,
    day = 1,
    hour = 12,
  })
  local today = os.time({ year = t.year, month = t.month, day = t.day, hour = 12 })
  return q, math.floor(os.difftime(next_quarter, today) / 86400)
end

clock:subscribe({ "forced", "routine", "system_woke" }, function()
  local now = os.time()
  local q, days = quarter_end(now)

  clock:set({ label = os.date("%H:%M", now) })
  date_day:set({ label = os.date("%d", now) })
  date_month:set({ label = os.date("%m", now) })
  quarter:set({ label = "Q" .. q })
  quarter_left:set({ label = days .. "d" })
end)
