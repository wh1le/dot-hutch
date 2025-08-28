return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"mfussenegger/nvim-dap-python",
		"nvim-neotest/nvim-nio",
		"igorlfs/nvim-dap-view",
		"theHamsta/nvim-dap-virtual-text",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dap-view")

    local function dapview_open_and_focus()
      vim.cmd("DapViewOpen")  -- command provided by nvim-dap-view
      vim.schedule(function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
          if ft == "dap-view" then                   -- prefer the main view, not the terminal
            vim.api.nvim_set_current_win(win)
            return
          end
        end
        -- fallback: focus the REPL/terminal if only that exists
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
          if ft == "dap-view-term" or ft == "dap-repl" then
            vim.api.nvim_set_current_win(win)
            return
          end
        end
      end)
    end

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

		vim.g.__dap_view_open = false

		local function dapui_toggle()
			if vim.g.__dap_view_open then
				dapui.close()
			else
        dapview_open_and_focus()
        vim.g.__dap_view_open = true
			end
			vim.g.__dap_view_open = not vim.g.__dap_view_open
		end

    dap.listeners.after.event_initialized["dapview-open-focus"] = function()
			vim.g.__dap_view_open = true
      dapview_open_and_focus()
    end

		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
			vim.g.__dap_view_open = true
		end

		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
			vim.g.__dap_view_open = true
		end

		vim.keymap.set("n", "<leader>dc", function() dap.continue()  end, { desc = "DAP Continue" })
		vim.keymap.set("n", "<leader>dq", function() dap.terminate() end, { desc = "DAP Quit" })
		vim.keymap.set("n", "<leader>dn", function() dap.step_over() end, { desc = "DAP Step Over" })
		vim.keymap.set("n", "<leader>di", function() dap.step_into() end, { desc = "DAP Step Into" })
		vim.keymap.set("n", "<leader>do", function() dap.step_out() end, { desc = "DAP Step Out" })
		vim.keymap.set("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "DAP Toggle Breakpoint" })
		vim.keymap.set("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { desc = "DAP Conditional Breakpoint" })
		vim.keymap.set("n", "<leader>du", function() dapui_toggle() end, { desc = "DAP UI Toggle" })


		-- update icons
		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticSignError", numhl = "" })
		vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticSignWarn", numhl = "" })
		vim.fn.sign_define("DapStopped", { text = "➜", texthl = "DiagnosticSignInfo", numhl = "" })

    -- virtual text
		require("nvim-dap-virtual-text").setup({
			enabled = true,
			all_references = false, -- show on every reference (so when you land on it)
			only_first_definition = true,
			virt_text_pos = "eol", -- stick to end-of-line
			-- or pin to a fixed column on the right:
			-- virt_text_pos = "virt_text_win_col",
			-- virt_text_win_col = 100,
			highlight_changed_variables = true,
			commented = true,
		})
	end,
}
