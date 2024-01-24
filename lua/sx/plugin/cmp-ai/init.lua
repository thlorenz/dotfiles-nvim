local Log = require("sx.core.log")

local M = {}

M.setup = function()
	local status_ok, cmp_ai = pcall(require, "cmp_ai.config")
	if not status_ok then
		Log:error("Failed to load cmp_ai.config")
		return
	end

	cmp_ai:setup({
		max_lines = 1000,
		provider = "Bard",
		notify = true,
		run_on_every_keystroke = true,
		ignored_file_types = {},
	})
end

return M
