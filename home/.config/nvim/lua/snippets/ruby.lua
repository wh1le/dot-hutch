local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node

-- Helper: Process/Source Logic
local function get_ruby_structure()
	local path = vim.fn.expand("%:.:r")
	local parts = {}
	for part in path:gmatch("[^/]+") do
		table.insert(parts, part)
	end

	local start_index = 1
	if parts[1] == "app" or parts[1] == "lib" then
		start_index = 2
	end

	local modules = {}
	for j = start_index, #parts - 1 do
		local camel = parts[j]
			:gsub("(%l)(%w*)", function(a, b)
				return string.upper(a) .. b
			end)
			:gsub("_", "")
		table.insert(modules, camel)
	end

	local class_name = parts[#parts]
		:gsub("(%l)(%w*)", function(a, b)
			return string.upper(a) .. b
		end)
		:gsub("_", "")
	local base_class = (modules[1] or "Object") .. "::Base"

	return modules, class_name, base_class
end

-- Helper: RSpec Logic
local function get_rspec_structure()
	local path = vim.fn.expand("%:.:r")
	local parts = {}
	for part in path:gmatch("[^/]+") do
		table.insert(parts, part)
	end

	local start_index = (parts[1] == "spec") and 2 or 1

	local full_namespace = {}
	for j = start_index, #parts do
		local segment = parts[j]:gsub("_spec$", "")
		local camel = segment
			:gsub("(%l)(%w*)", function(a, b)
				return string.upper(a) .. b
			end)
			:gsub("_", "")
		table.insert(full_namespace, camel)
	end
	return table.concat(full_namespace, "::")
end

-- Return the table of snippets
return {
	-- Snippet: Minitest boilerplate (mtest)
	s("mtest", {
		t({ "require 'minitest/pride'", "", "" }),
		t("class "),
		i(1, "SolutionTest"),
		t(" < Minitest::Test"),
		t({ "", "  def test_" }),
		i(2, "it_works"),
		t({ "", "    assert_equal " }),
		i(3, "expected"),
		t(", "),
		i(4, "actual"),
		t({ "", "  end", "end" }),
	}),

	-- Snippet: class with modules (cla)
	s("cla", {
		d(1, function()
			local modules, class_name, base_class = get_ruby_structure()
			local nodes = {}
			local indent = ""

			for _, mod in ipairs(modules) do
				table.insert(nodes, t({ indent .. "module " .. mod, "" }))
				indent = indent .. "  "
			end

			table.insert(nodes, t(indent .. "class " .. class_name .. " < " .. base_class))
			table.insert(nodes, t({ "", indent .. "  def initialize(" }))
			table.insert(nodes, i(1, "args"))
			table.insert(nodes, t({ ")", indent .. "    " }))
			table.insert(nodes, i(2))
			table.insert(nodes, t({ "", indent .. "  end", "" }))
			table.insert(nodes, t({ "", indent .. "  private", "", indent .. "  attr_reader :" }))
			table.insert(nodes, i(3, "attributes"))
			table.insert(nodes, t({ "", indent .. "end", "" }))

			for j = #modules, 1, -1 do
				indent = indent:sub(1, -3)
				table.insert(nodes, t({ indent .. "end", "" }))
			end
			return sn(nil, nodes)
		end),
	}),

	-- Snippet: RSpec Describe (desc)
	s("desc", {
		t("frozen_string_literal: true"),
		t({ "", "", "RSpec.describe " }),
		f(function()
			return get_rspec_structure()
		end),
		t(", type: :"),
		f(function()
			local path = vim.fn.expand("%:p")
			if path:match("/spec/models/") then
				return "model"
			elseif path:match("/spec/requests/") then
				return "request"
			elseif path:match("/spec/processes/") then
				return "process"
			end
			return "type"
		end),
		t({ " do", "  describe " }),
		i(1, '"#method"'),
		t({ " do", "    it " }),
		i(2, '"does something"'),
		t({ " do", "      " }),
		i(0),
		t({ "", "    end", "  end", "end" }),
	}),
}
