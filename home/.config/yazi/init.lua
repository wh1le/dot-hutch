local ok, wal = pcall(dofile, os.getenv("HOME") .. "/.cache/wal/colors.lua")
Colors = ok and wal or {}

function Linemode:size_and_mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%b %d %H:%M", time)
	else
		time = os.date("%b %d  %Y", time)
	end

	local size = self._file:size()
	return ui.Line(string.format("%s %s", size and ya.readable_size(size) or "", time))
		:style(th.status.perm_sep)
		:bold(true)
end

-- Symlink target (" -> ...") inherits the entry's bold from the filetype rule;
-- strip it so only the name stays bold.
local entity_symlink = Entity.symlink
function Entity:symlink()
	local span = entity_symlink(self)
	return span == "" and span or span:bold(true)
end

-- Extend the hovered row highlight to fill the trailing gap on the right,
-- so the current item spans the full pane width. Style comes from theme.toml.
local function append_hover_fill(t, self, style)
	local fillers = {}
	for i, f in ipairs(self._folder.window) do
		fillers[i] = f.is_hovered and ui.Line(" "):style(style) or ui.Line("")
	end
	t[#t + 1] = ui.Text(fillers):area(self._area):align(ui.Align.RIGHT)
end

-- yazi has no native pane scrollbar; draw one on the right edge when the list
-- overflows the visible height. Thumb size/position track the scroll offset.
-- Color inherits the theme's pane chrome (theme.toml [mgr] border_style).
local scrollbar_style = th.mgr.border_style
local function append_scrollbar(t, self)
	local folder, area = self._folder, self._area
	local total, height = #folder.files, area.h
	if total <= height or height <= 0 then
		return
	end

	local thumb = math.max(1, math.floor(height * height / total))
	local pos = math.floor(folder.offset * (height - thumb) / (total - height) + 0.5)

	local lines = {}
	for i = 0, height - 1 do
		lines[#lines + 1] = ui.Line((i >= pos and i < pos + thumb) and "▐" or " ")
	end
	t[#t + 1] = ui.Text(lines)
		:area(ui.Rect({ x = area.x + area.w - 1, y = area.y, w = 1, h = height }))
		:style(scrollbar_style)
end

local current_redraw = Current.redraw
function Current:redraw()
	local t = current_redraw(self)
	append_hover_fill(t, self, th.indicator.current)
	append_scrollbar(t, self)
	return t
end

local parent_redraw = Parent.redraw
function Parent:redraw()
	local t = parent_redraw(self)
	append_hover_fill(t, self, th.indicator.parent)
	append_scrollbar(t, self)
	return t
end

-- Directory previews render a file-list that reserves a leading marker column;
-- text/image previews don't. Add 1 col for non-dir previews so every preview
-- lines up at the same left offset.
local old_tab_build = Tab.build
Tab.build = function(self, ...)
	local hovered = cx.active.current.hovered
	local is_dir = hovered and hovered.cha.is_dir
	self._chunks[3] = self._chunks[3]:pad(ui.Pad.left(is_dir and 0 or 1))
	old_tab_build(self, ...)
end

require("duckdb"):setup({
	auto_install_extensions = false,
	cache_enabled = false,
})

require("font-sample"):setup({})

require("eza-preview"):setup({
	default_tree = false,
	level = 1,
	icons = true,
	follow_symlinks = true,
	dereference = false,
	all = true,
	ignore_glob = {},
	git_ignore = false,
	git_status = false,
})
