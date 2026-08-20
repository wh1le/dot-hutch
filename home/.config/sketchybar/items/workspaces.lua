local colors = require("colors")
local settings = require("settings")

sbar.add("event", "aerospace_workspace_change")

local function lines(str)
	local out = {}
	for line in str:gmatch("[^\r\n]+") do
		table.insert(out, (line:gsub("%s+$", "")))
	end
	return out
end

local function label_for(ws)
	return ws == "0" and "10" or ws
end

local handle = io.popen("/opt/homebrew/bin/aerospace list-workspaces --all")
local workspaces = lines(handle and handle:read("*a") or "")
if handle then
	handle:close()
end

table.sort(workspaces, function(a, b)
	local na = tonumber(a) or 0
	local nb = tonumber(b) or 0
	if na == 0 then return false end
	if nb == 0 then return true end
	return na < nb
end)

sbar.add("item", "space.left_padding", {
	position = "left",
	width = 4,
	background = { drawing = false },
	icon = { drawing = false },
	label = { drawing = false },
})

local items = {}
local occupied = {}
local focused = nil

local function refresh()
	for _, ws in ipairs(workspaces) do
		local space = items[ws]
		local selected = focused == ws
		space:set({
			drawing = selected or occupied[ws] or false,
			icon = { highlight = selected },
			background = { color = selected and colors.accent or colors.transparent },
		})
	end
end

local function update_occupancy(then_call)
	sbar.exec("/opt/homebrew/bin/aerospace list-windows --all --format '%{workspace}'", function(result)
		occupied = {}
		for _, ws in ipairs(lines(result)) do
			occupied[ws] = true
		end
		refresh()
		if then_call then
			then_call()
		end
	end)
end

for _, ws in ipairs(workspaces) do
	local space = sbar.add("item", "space." .. ws, {
		position = "left",
		drawing = false,
		icon = {
			font = {
				family = settings.font.numbers,
				style = settings.font.style_map["Bold"],
				size = 12.0,
			},
			string = label_for(ws),
			width = 20,
			align = "center",
			padding_left = 0,
			padding_right = 0,
			color = colors.fg,
			highlight_color = colors.bg,
		},
		label = { drawing = false },
		padding_left = 0,
		padding_right = 0,
		background = {
			color = colors.transparent,
			border_width = 0,
			height = 22,
			corner_radius = 0,
		},
		click_script = "/opt/homebrew/bin/aerospace workspace " .. ws,
	})

	items[ws] = space

	space:subscribe("aerospace_workspace_change", function(env)
		focused = env.FOCUSED_WORKSPACE
		update_occupancy()
	end)
end

local observer = sbar.add("item", "space.observer", {
	drawing = false,
	updates = true,
	update_freq = 5,
})

observer:subscribe({ "routine", "forced", "front_app_switched", "system_woke" }, function()
	update_occupancy()
end)

sbar.exec("/opt/homebrew/bin/aerospace list-workspaces --focused", function(result)
	focused = (result:gsub("%s+", ""))
	update_occupancy()
end)
