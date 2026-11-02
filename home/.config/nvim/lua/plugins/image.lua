return {
	"3rd/image.nvim",
	build = false,
	event = "BufReadPre *.png,*.jpg,*.jpeg,*.gif,*.webp,*.avif,*.svg",
	ft = { "markdown" },
	opts = {
		processor = "magick_cli",
		tmux_show_only_in_active_window = true,
		window_overlap_clear_enabled = true,
		window_overlap_clear_ft_ignore = {
			"cmp_menu",
			"cmp_docs",
			"",
		},
		hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif", "*.svg" },
	},
}
