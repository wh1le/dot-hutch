return {
	"3rd/image.nvim",
	build = false,
	opts = {
		processor = "magick_cli",
		-- Add these options:
		tmux_show_only_in_active_window = true,
		window_overlap_clear_enabled = true,
		window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
		-- Clean up images aggressively
		hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
	},
	config = function(_, opts)
		require("image").setup(opts)

		-- Clear all images on exit to prevent escape sequence leaks
		vim.api.nvim_create_autocmd("VimLeavePre", {
			callback = function()
				require("image").clear()
				-- Send explicit clear command to kitty
				vim.defer_fn(function()
					io.stdout:write("\x1b_Ga=d,q=2\x1b\\")
					io.stdout:flush()
				end, 50)
			end,
		})
	end,
}
