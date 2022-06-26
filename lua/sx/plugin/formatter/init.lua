local M = {}
local Log = require("sx.core.log")

M.setup = function()
	if #vim.api.nvim_list_uis() == 0 then
		Log:debug("headless mode detected, skipping running setup for formatter")
		return
	end

	local status_ok, formatter = pcall(require, "formatter")
	if not status_ok then
		Log:error("Failed to load formatter")
	end

	local function prettierd()
		-- npm install -g @fsouza/prettierd
		return {
			exe = "prettierd",
			args = { vim.api.nvim_buf_get_name(0) },
			stdin = true,
			try_node_modules = true,
		}
	end

	local function prettier()
		return {
			exe = "prettierd",
			args = { "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
			stdin = true,
			try_node_modules = true,
		}
	end

	formatter.setup({
		filetype = {
			-- Prettier for TS/JS + JSON
			typescript = prettierd,
			typescriptreact = prettierd,
			javascript = prettierd,
			javascriptreact = prettierd,
			json = prettierd,
			lua = {
				-- cargo install stylua
				function()
					return {
						exe = "stylua",
						args = {
							"--search-parent-directories",
							"--stdin-filepath",
							vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
							"--",
							"-",
						},
						stdin = true,
					}
				end,
			},
			["*"] = {
				function()
					vim.cmd([[ %s/\s\+$//e ]])
				end,
			},
		},
	})

	vim.cmd([[
    augroup FormatAutogroup
      autocmd!
      autocmd BufWritePost * FormatWrite
    augroup END
  ]])
end

return M
