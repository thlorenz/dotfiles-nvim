local Log = require("sx.core.log")

local M = {}

-- NOTE: that this includes dap-ui setup as they are tightly coupled
M.setup = function()
	local status_ok, dap_install = pcall(require, "dap-install")
	if not status_ok then
		Log:error("Failed to load dap-ui")
		return
	end
	dap_install.setup({
		installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
	})
end

return M
