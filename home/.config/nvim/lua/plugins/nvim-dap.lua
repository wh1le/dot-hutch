return {
	"mfussenegger/nvim-dap",
	ft = { "python", "ruby" },
	cmd = { "DapContinue", "DapToggleBreakpoint" },
	lazy = true,
	dependencies = {
		"nvim-neotest/nvim-nio",
		"igorlfs/nvim-dap-view",
		"theHamsta/nvim-dap-virtual-text",
		-- adapters
		"mfussenegger/nvim-dap-python",
		"suketa/nvim-dap-ruby",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dap-view")
		local ruby = require("dap-ruby")
		ruby.setup()

		dapui.setup({
			winbar = {
				sections = {
					"scopes",
					"repl",
					"watches",
					"exceptions",
					"breakpoints",
					"threads",
					"console",
				},
				default_section = "scopes",
			},
		})

		-- Open dap-view and focus its main window
		local function dapview_open_and_focus()
			vim.cmd("DapViewOpen") -- provided by nvim-dap-view
			vim.schedule(function()
				-- prefer the main view; fall back to repl/term
				local ft_priority = { "dap-view", "dap-repl", "dap-view-term" }
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local buf = vim.api.nvim_win_get_buf(win)
					local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
					for _, want in ipairs(ft_priority) do
						if ft == want then
							vim.api.nvim_set_current_win(win)
							return
						end
					end
				end
			end)
		end

		vim.g.__dap_view_open = false
		local function dapview_toggle()
			if vim.g.__dap_view_open then
				vim.cmd("DapViewClose")
				vim.g.__dap_view_open = false
			else
				dapview_open_and_focus()
				vim.g.__dap_view_open = true
			end
		end

		-- auto-open + focus when a session starts; auto-close on end
		dap.listeners.after.event_initialized["dapview-open-focus"] = function()
			dapview_open_and_focus()
			vim.g.__dap_view_open = true
		end

		dap.listeners.before.event_terminated["dapview-close"] = function()
			vim.cmd("DapViewClose")
			vim.g.__dap_view_open = false
		end

		dap.listeners.before.event_exited["dapview-close"] = function()
			vim.cmd("DapViewClose")
			vim.g.__dap_view_open = false
		end

		-- keys
		vim.keymap.set("n", "<leader>dc", function()
			dap.continue()
		end, { desc = "DAP Continue" })
		vim.keymap.set("n", "<leader>dq", function()
			dap.terminate()
		end, { desc = "DAP Quit" })
		vim.keymap.set("n", "<leader>dn", function()
			dap.step_over()
		end, { desc = "DAP Step Over" })
		vim.keymap.set("n", "<leader>di", function()
			dap.step_into()
		end, { desc = "DAP Step Into" })
		vim.keymap.set("n", "<leader>do", function()
			dap.step_out()
		end, { desc = "DAP Step Out" })
		vim.keymap.set("n", "<leader>db", function()
			dap.toggle_breakpoint()
		end, { desc = "DAP Toggle Breakpoint" })
		vim.keymap.set("n", "<leader>dB", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "DAP Conditional Breakpoint" })
		vim.keymap.set("n", "<leader>du", function()
			dapui_toggle()
		end, { desc = "DAP UI Toggle" })

		-- signs
		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticSignError", numhl = "" })
		vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticSignWarn", numhl = "" })
		vim.fn.sign_define("DapStopped", { text = "➜", texthl = "DiagnosticSignInfo", numhl = "" })

		-- virtual text
		require("nvim-dap-virtual-text").setup({
			enabled = true,
			all_references = false,
			only_first_definition = true,
			virt_text_pos = "eol",
			highlight_changed_variables = true,
			commented = true,
		})
	end,
}
