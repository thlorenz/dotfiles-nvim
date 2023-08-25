local M = {}

local Log = require("sx.core.log")
local lsp = require("sx.plugin.lsp")

local function config(cmp)
	return {

		snippet = {
			expand = function(args)
				vim.fn["UltiSnips#Anon"](args.body)
			end,
		},

		mapping = {
			["<C-Space>"] = cmp.mapping.complete(),
			["<Tab>"] = cmp.mapping.confirm({ select = true }),
			["<C-n>"] = function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				else
					fallback()
				end
			end,
			["<C-p>"] = function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				else
					fallback()
				end
			end,
		},
		sources = {
			-- { name = "copilot" },
			{ name = "path" },
			{ name = "cmp_ai" },
			{ name = "ultisnips" },
			{ name = "nvim_lua" },
			{ name = "nvim_lsp" },
			{ name = "buffer", keyword_length = 5 },
			{ name = "calc" },
			{ name = "treesitter" },
			{ name = "crates" },
			{ name = "tmux" },
		},

		formatting = require("sx.plugin.cmp.formatting"),
	}
end

function M.setup()
	if #vim.api.nvim_list_uis() == 0 then
		Log:debug("headless mode detected, skipping running setup for lsp/cmp")
		return
	end

	-- cmp
	local status_ok, cmp = pcall(require, "cmp")
	if not status_ok then
		Log:error("Failed to load cmp")
		return
	end

	local conf = config(cmp)
	cmp.setup(conf)

	-- lspconfig + typescript + json
	local status_ok, lspconfig = pcall(require, "lspconfig")
	if not status_ok then
		Log:error("Failed to load lspconfig")
		return
	end

	local capabilities = require("cmp_nvim_lsp").default_capabilities(
		vim.lsp.protocol.make_client_capabilities()
	)
	capabilities.textDocument.completion.completionItem.snippetSupport = true

	-- TypeScript
	lspconfig.tsserver.setup({
		capabilities = capabilities,
		init_options = {
			importModuleSpecifier = "relative",
		},
		initOptions = {
			importModuleSpecifier = "relative",
		},
		preferences = {
			importModuleSpecifier = "relative",
		},
	})

	-- JSON Schema Support
	lspconfig.jsonls.setup({
		capabilities = capabilities,
		settings = lsp.json_settings(),
	})

	-- keymaps
	vim.cmd([[
    nnoremap gd :lua vim.lsp.buf.definition()<CR>
    nnoremap gr :Telescope lsp_references<CR>
    nnoremap K :lua vim.lsp.buf.hover()<CR>
  ]])

	-- ultisnips
	vim.cmd([[ let g:UltiSnipsSnippetsDir = "~/.config/nvim/UltiSnips" ]])
end

return M
