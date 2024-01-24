local M = {}
local Log = require("sx.core.log")

M.setup = function()
	if #vim.api.nvim_list_uis() == 0 then
		Log:debug(
			"headless mode detected, skipping running setup for formatter"
		)
		return
	end

	-- https://github.com/mhartington/formatter.nvim
	local status_ok, formatter = pcall(require, "formatter")
	if not status_ok then
		Log:error("Failed to load formatter")
	end
	local filetypes = require("formatter.filetypes")

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
			exe = "prettier",
			args = {
				"--stdin-filepath",
				vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
			},
			stdin = true,
			try_node_modules = true,
		}
	end

	formatter.setup({
		filetype = {
			-- Prettier for TS/JS + JSON
			typescript = filetypes.typescript.prettierd,
			typescriptreact = filetypes.typescript.prettierd,
			javascript = filetypes.javascript.prettier,
			javascriptreact = filetypes.javascript.prettierd,
			json = filetypes.json.prettierd,

			-- cargo install taplo-cli --locked
			toml = filetypes.toml.taplo,

			-- brew install libyaml
			-- python -m pip install pyyaml
			-- Disabled since it screws up docker-compose files (removing ' from strings)
			-- also it reorders alphabetically and I don't know how to turn that off
			-- yaml = filetypes.yaml.pyaml,

			-- cargo install stylua
			lua = filetypes.lua.stylua,

			rust = filetypes.rust.rustfmt,

			["*"] = filetypes.any,
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
