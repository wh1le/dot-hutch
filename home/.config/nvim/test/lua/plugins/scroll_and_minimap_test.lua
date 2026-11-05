-- Run: nvim --headless -u NONE -l test/lua/plugins/scroll_and_minimap_test.lua
local function test_minimap_adapts_to_terminal_size()
	local spec = dofile("lua/plugins/scroll_and_minimap.lua")
	local calls = 0
	package.loaded.scroll = {
		setup = function()
			calls = calls + 1
		end,
	}

	vim.o.lines, vim.o.columns = 30, 180
	spec.config(nil, spec.opts)
	assert(spec.opts.minimap.width == 7, "short terminals use a compact map")
	assert(spec.opts.minimap.columns_per_dot == 6, "compact maps retain code coverage")

	vim.api.nvim_exec_autocmds("VimResized", {})
	assert(calls == 1, "unchanged size must not restart scroll")

	vim.o.lines = 60
	vim.api.nvim_exec_autocmds("VimResized", {})
	assert(spec.opts.minimap.width == 14, "large terminals restore the full map")
	assert(spec.opts.minimap.columns_per_dot == 3)

	vim.o.columns = 100
	vim.api.nvim_exec_autocmds("VimResized", {})
	assert(spec.opts.minimap.width == 7, "narrow terminals use a compact map")
	assert(calls == 3)

	assert(spec.opts.horizontal.enabled == false, "binary-unsafe width scans stay disabled")
	assert(spec.opts.minimap.enabled, "the minimap remains enabled")
end

test_minimap_adapts_to_terminal_size()

-- Exercise the installed plugin too, including switching back to a normal file.
package.loaded.scroll = nil
vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/lazy/scroll.nvim")
local spec = dofile("lua/plugins/scroll_and_minimap.lua")
vim.o.lines, vim.o.columns = 60, 180
spec.config(nil, spec.opts)
require("scroll.width").get = function()
	error("the binary-unsafe width scanner must not run")
end
local win = vim.api.nvim_get_current_win()
for _, text in ipairs({ "\127ELF\0binary", string.rep("x", 1024), "normal text" }) do
	local buf = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.fn["repeat"]({ text }, 3000))
	vim.api.nvim_win_set_buf(win, buf)
	local computed = require("scroll.render").compute(win)
	assert(computed.minimap, "binary, large and subsequent normal buffers keep the minimap")
	assert(not computed.horizontal, "no horizontal width scan")
	require("scroll").refresh()
	vim.wait(50)
end
require("scroll").disable()
print("PASS: resizing, binary/large buffers and switching back to normal text")
