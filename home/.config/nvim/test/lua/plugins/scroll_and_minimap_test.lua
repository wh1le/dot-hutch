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
end

test_minimap_adapts_to_terminal_size()
print("PASS: minimap adapts to terminal size")
