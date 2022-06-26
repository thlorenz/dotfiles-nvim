local M = {}

local Log = require("sx.core.log")

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
			{ name = "ultisnips" },
			{ name = "nvim_lua" },
			{ name = "nvim_lsp" },
			{ name = "path" },
			{ name = "buffer", keyword_length = 5 },
			{ name = "calc" },
			{ name = "treesitter" },
			{ name = "crates" },
			{ name = "tmux" },
		},

		formatting = require("sx.plugin.lsp.formatting"),
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
	end

	local status_ok, ultisnips = pcall(require, "ultisnips")
	if not status_ok then
		Log:error("Failed to load ultisnips")
	end

	local conf = config(cmp)
	cmp.setup(conf)

	-- lspconfig
	local status_ok, lspconfig = pcall(require, "lspconfig")
	if not status_ok then
		Log:error("Failed to load lspconfig")
	end

	lspconfig.tsserver.setup({
		capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
	})

	-- ultisnips
	vim.cmd([[ let g:UltiSnipsSnippetsDir = "~/.config/nvim/UltiSnips" ]])

	-- keymaps
	vim.cmd([[
    nnoremap gd :lua vim.lsp.buf.definition()<CR>
    nnoremap K :lua vim.lsp.buf.hover()<CR>
    nnoremap <leader>. :lua vim.lsp.buf.code_action()<CR>
    nnoremap <leader>rn :lua vim.lsp.buf.rename()<CR>
  ]])
end

return M
