local M = {}

local Log = require("sx.core.log")

local function config(cmp, luasnip)
	return {

		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
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
			{ name = "luasnip" },
			{ name = "nvim_lsp" },
			{ name = "buffer" },
		},
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

	local status_ok, luasnip = pcall(require, "luasnip")
	if not status_ok then
		Log:error("Failed to load luasnip")
	end

	local conf = config(cmp, luasnip)
	cmp.setup(conf)

	-- lspconfig
	local status_ok, lspconfig = pcall(require, "lspconfig")
	if not status_ok then
		Log:error("Failed to load lspconfig")
	end

	lspconfig.tsserver.setup({
		capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
	})

	-- keymaps
	vim.cmd([[
    nnoremap gd :lua vim.lsp.buf.definition()<CR>
    nnoremap K :lua vim.lsp.buf.hover()<CR>
    nnoremap <leader>. :lua vim.lsp.buf.code_action()<CR>
    nnoremap <leader>rn :lua vim.lsp.buf.rename()<CR>
  ]])
end

return M
