local Log = require("sx.core.log")

local M = {}

M.setup = function(dap)
	local status_ok, dapui = pcall(require, "dapui")
	if not status_ok then
		Log:error("Failed to load dap-ui")
		return
	end

	local breakpoint = {
		text = "",
		texthl = "LspDiagnosticsSignError",
		linehl = "",
		numhl = "",
	}
	local breakpoint_rejected = {
		text = "",
		texthl = "LspDiagnosticsSignHint",
		linehl = "",
		numhl = "",
	}
	local stopped = {
		text = "",
		texthl = "LspDiagnosticsSignInformation",
		linehl = "DiagnosticUnderlineInfo",
		numhl = "LspDiagnosticsSignInformation",
	}

	vim.fn.sign_define("DapBreakpoint", breakpoint)
	vim.fn.sign_define("DapBreakpointRejected", breakpoint_rejected)
	vim.fn.sign_define("DapStopped", stopped)

	dap.defaults.fallback.terminal_win_cmd = "50vsplit new"

	dap.configurations.rust = {
		{
			name = "Launch file",
			type = "codelldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = true,
		},
	}
end

return M
