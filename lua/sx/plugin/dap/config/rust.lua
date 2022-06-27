local dap = require("dap")
local M = {}

function M.setup(dap)
	dap.adapters.lldb = {
		type = "executable",
		command = "lldb-vscode",
		name = "lldb",
	}
	dap.configurations.rust = {
		{
			name = "Launch",
			type = "lldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
			args = {},
		},
	}
end

return M
