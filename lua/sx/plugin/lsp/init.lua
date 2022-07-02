local M = {}

local function setup_diags()
	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
		vim.lsp.diagnostic.on_publish_diagnostics,
		{
			virtual_text = true,
			signs = true,
			update_in_insert = false,
			underline = true,
		}
	)
end

function M.source()
	setup_diags()
end

return M
