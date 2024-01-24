local M = {}

function M.setup()
	local status_ok, smart_splits = pcall(require, "smart-splits")
	if not status_ok then
		Log:error("Failed to load smart-splits")
		return
	end

	smart_splits.setup({
		ignored_filetypes = {
			"nofile",
			"quickfix",
			"prompt",
		},
		ignored_buftypes = { "NvimTree" },
		move_cursor_same_row = false,
		resize_mode = {
			quit_key = "w",
			resize_keys = { "h", "j", "k", "l" },
			silent = true,
		},
		hooks = {
			on_enter = function() end,
			on_leave = function() end,
		},
	})
end

return M
