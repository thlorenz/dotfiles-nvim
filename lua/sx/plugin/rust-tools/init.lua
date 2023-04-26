local Log = require("sx.core.log")

local M = {}

local clippyTests = {
	"cargo",
	"clippy",
	"--tests",
	-- "--all-features",

	"--message-format=json",
}

local check = {
	"cargo",
	"check",

	"--message-format=json",
}

local checkTests = {
	"cargo",
	"check",
	"--tests",

	"--message-format=json",
}

-- Custom
local chainsawBench = {
	"cargo",
	"build",
	"--features=bson,json",
	"--bench=deserialization",

	"--message-format=json",
}

local chainsawNetwork = {
	"cargo",
	"build",
	"--features=bson,network",

	"--message-format=json",
}

local clippyFeaturesBson = {
	"cargo",
	"clippy",
	"--features=bson",

	"--message-format=json",
}

local clippyFeaturesNetworkTests = {
	"cargo",
	"clippy",
	"--features=network",
	"--tests",

	"--message-format=json",
}

local hulkLocal = {
	"cargo",
	"clippy",
	"--tests",
	"--features=test",

	"--message-format=json",
}

local function clippy(tests, features)
	local cmd = { "cargo", "clippy" }
	if tests then
		table.insert(cmd, "--tests")
	end
	if features then
		table.insert(cmd, "--features=" .. features)
	end
	table.insert(cmd, "--message-format=json")
	return cmd
end

M.setup = function()
	local status_ok, rust_tools = pcall(require, "rust-tools")
	if not status_ok then
		Log:error("Failed to load rust-tools")
		return
	end
	rust_tools.setup({
		tools = { -- rust-tools options
			autoSetHints = true,

			-- whether to show hover actions inside the hover window
			-- this overrides the default hover handler so something like lspsaga.nvim's hover would be overriden by this
			-- default: true
			hover_with_actions = false,
			-- whether the hover action window gets automatically focused
			-- default: false
			auto_focus = true,

			inlay_hints = {
				show_parameter_hints = false,
				parameter_hints_prefix = "",
				other_hints_prefix = "",
			},
		},

		hover_actions = {
			-- the border that is used for the hover window
			-- see vim.api.nvim_open_win()
			border = {
				{ "╭", "FloatBorder" },
				{ "─", "FloatBorder" },
				{ "╮", "FloatBorder" },
				{ "│", "FloatBorder" },
				{ "╯", "FloatBorder" },
				{ "─", "FloatBorder" },
				{ "╰", "FloatBorder" },
				{ "│", "FloatBorder" },
			},
		},
		-- all the opts to send to nvim-lspconfig
		-- these override the defaults set by rust-tools.nvim
		-- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
		server = {
			standalone = false,
			cmd = {
				-- nightly rustup component add rust-analyzer-preview
				"/Users/thlorenz/.rustup/toolchains/nightly-x86_64-apple-darwin/bin/rust-analyzer",
				-- brew install rust-analyzer
				-- "/usr/local/bin/rust-analyzer",
			},
			-- on_attach is a callback called when the language server attachs to the buffer
			-- on_attach = on_attach,
			settings = {
				-- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
				-- Schema: https://github.com/simrat39/rust-tools.nvim/blob/master/ci/schema/output.md
				["rust-analyzer"] = {
					updates = {
						channel = "nightly",
						prompt = true,
					},

					inlayHints = {
						maxLength = 18,
						chainingHints = true,
						typeHints = false,
					},
					diagnostics = {
						disabled = {
							"missing-unsafe",
							"inactive-code",
							"unresolved-proc-macro",
						},
					},
					procMacro = {
						enable = true,
					},
					lens = {
						enable = true,
						methodReferences = true,
					},
					cargo = {
						features = "all",
					},
					checkOnSave = {
						enable = true,
						allTargets = false,
						features = "all",
						-- overrideCommand = clippy(true, "test"),
						overrideCommand = clippy(false),
					},
				},
			},
		},
		dap = {
			adapter = {
				type = "executable",
				command = "lldb-vscode",
				name = "rt_lldb",
			},
		},
	})
end

return M
