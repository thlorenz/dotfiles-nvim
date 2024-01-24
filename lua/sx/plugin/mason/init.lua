-- Most from https://rsdlt.github.io/posts/rust-nvim-ide-guide-walkthrough-development-debug/

-- Ensure we use the tools installed by mason
vim.env.PATH = vim.fn.stdpath("data")
	.. "/mason/bin"
	.. (is_windows and "; " or ":")
	.. vim.env.PATH

-- Allows to run things likd :MasonInstall rust-analyzer codelldb
local M = {}

function M.setup()
	local status_ok, mason = pcall(require, "mason")
	if not status_ok then
		Log:error("Failed to load mason")
	end
	mason.setup({
		ui = {
			icons = {
				package_installed = "",
				package_pending = "",
				package_uninstalled = "",
			},
		},
	})

	local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
	if not status_ok then
		Log:error("Failed to load mason-lspconfig")
	end
	mason_lspconfig.setup()
end

return M
