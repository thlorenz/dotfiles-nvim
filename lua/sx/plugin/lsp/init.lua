local M = {}

local function setup_diags()
	vim.lsp.handlers["textDocument/publishDiagnostics"] =
		vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
			virtual_text = true,
			signs = true,
			update_in_insert = false,
			underline = true,
		})
end

local function setup_lsp_util()
	-- https://github.com/neovim/nvim-lspconfig/issues/2357#issuecomment-1365452173
	local params = lsp.util.make_workspace_params({
		{ uri = vim.uri_from_fname(root_dir), name = root_dir },
	})
end

function M.json_settings()
	-- npm i -g vscode-langservers-extracted
	return {
		json = {
			schemas = {
				{
					description = "TypeScript compiler configuration file",
					fileMatch = { "tsconfig.json", "tsconfig.*.json" },
					url = "http://json.schemastore.org/tsconfig",
				},
				{
					description = "Lerna config",
					fileMatch = { "lerna.json" },
					url = "http://json.schemastore.org/lerna",
				},
				{
					description = "Babel configuration",
					fileMatch = {
						".babelrc.json",
						".babelrc",
						"babel.config.json",
					},
					url = "http://json.schemastore.org/lerna",
				},
				{
					description = "ESLint config",
					fileMatch = { ".eslintrc.json", ".eslintrc" },
					url = "http://json.schemastore.org/eslintrc",
				},
				{
					description = "Bucklescript config",
					fileMatch = { "bsconfig.json" },
					url = "https://bucklescript.github.io/bucklescript/docson/build-schema.json",
				},
				{
					description = "Prettier config",
					fileMatch = {
						".prettierrc",
						".prettierrc.json",
						"prettier.config.json",
					},
					url = "http://json.schemastore.org/prettierrc",
				},
				{
					description = "Vercel Now config",
					fileMatch = { "now.json" },
					url = "http://json.schemastore.org/now",
				},
				{
					description = "Stylelint config",
					fileMatch = {
						".stylelintrc",
						".stylelintrc.json",
						"stylelint.config.json",
					},
					url = "http://json.schemastore.org/stylelintrc",
				},
			},
			validate = { enable = true },
		},
	}
end

function M.source()
	setup_diags()
end

return M
