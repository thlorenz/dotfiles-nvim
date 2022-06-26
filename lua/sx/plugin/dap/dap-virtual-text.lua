local Log = require("sx.core.log")

local M = {}

M.setup = function()
	local status_ok, dap_virtual_text = pcall(require, "nvim-dap-virtual-text")
	if not status_ok then
		Log:error("Failed to load nvim-dap-virtual-text")
		return
	end
	dap_virtual_text.setup({
		commented = true,
	})
end

return M
