local function read_wal()
  local out = {}
  local handle = io.open(os.getenv("HOME") .. "/.cache/wal/colors", "r")
  if not handle then return out end
  for line in handle:lines() do
    local hex = line:match("^#(%x%x%x%x%x%x)$")
    if hex then table.insert(out, tonumber("0xff" .. hex)) end
  end
  handle:close()
  return out
end

local wal = read_wal()

local function wal_color(index, fallback)
  return wal[index + 1] or fallback
end

local bg = wal_color(0, 0xff090e15)
local fg = wal_color(7, 0xffc1c2c4)
local accent = wal_color(4, 0xff5195ac)
local urgent = wal_color(1, 0xff327289)

return {
  bg = bg,
  fg = fg,
  accent = accent,
  urgent = urgent,

  black = bg,
  white = fg,
  cream = 0xfffffdd0,
  red = 0xffea6962,
  green = 0xff8ec07c,
  blue = accent,
  yellow = 0xffd8a657,
  orange = 0xffe78a4e,
  magenta = 0xffd3869b,
  grey = 0xff9b9da1,
  dim = 0xff55585e,
  transparent = 0x00000000,

  bar = {
    bg = bg,
    border = bg,
  },
  popup = {
    bg = bg,
    border = 0xff55585e,
  },
  bg1 = bg,
  bg2 = wal_color(8, 0xff58616c),

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
