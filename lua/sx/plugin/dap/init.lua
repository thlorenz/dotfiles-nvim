local Log = require("sx.core.log")

local M = {}

M.setup = function()
	if #vim.api.nvim_list_uis() == 0 then
		Log:debug("headless mode detected, skipping running setup for dap")
		return
	end

	local status_ok, dap = pcall(require, "dap")
	if not status_ok then
		Log:error("Failed to load dap-ui")
		return
	end

	require("sx.plugin.dap.dap").setup(dap)
	require("sx.plugin.dap.dap-ui").setup(dap)
	require("sx.plugin.dap.dap-install").setup()
	require("sx.plugin.dap.dap-virtual-text").setup()
	require("sx.plugin.dap.config.lua").setup(dap)
end

return M
