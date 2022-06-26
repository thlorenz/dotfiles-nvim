local Log = require("sx.core.log")

local M = {}

local function config()
	local conf = {
		setup = {
			plugins = {
				marks = true, -- shows a list of your marks on ' and `
				registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
				-- the presets plugin, adds help for a bunch of default keybindings in Neovim
				-- No actual key bindings are created
				presets = {
					operators = false, -- adds help for operators like d, y, ...
					motions = false, -- adds help for motions
					text_objects = false, -- help for text objects triggered after entering an operator
					windows = false, -- default bindings on <c-w>
					nav = true, -- misc bindings to work with windows
					z = true, -- bindings for folds, spelling and others prefixed with z
					g = true, -- bindings for prefixed with g
				},
				spelling = { enabled = true, suggestions = 20 }, -- use which-key for spelling hints
			},
			icons = {
				breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
				separator = "➜", -- symbol used between a key and it's label
				group = "+", -- symbol prepended to a group
			},
			popup_mappings = {
				scroll_down = "<c-d>", -- binding to scroll down inside the popup
				scroll_up = "<c-u>", -- binding to scroll up inside the popup
			},
			window = {
				border = "single", -- none, single, double, shadow
				position = "bottom", -- bottom, top
				margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
				padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
				winblend = 0,
			},
			layout = {
				height = { min = 4, max = 25 }, -- min and max height of the columns
				width = { min = 20, max = 50 }, -- min and max width of the columns
				spacing = 3, -- spacing between columns
				align = "left", -- align columns left, center or right
			},
			hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
			ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
			show_help = true, -- show help message on the command line when the popup is visible
			triggers = "auto", -- automatically setup triggers
			-- triggers = {"<leader>"} -- or specify a list manually
			triggers_blacklist = {
				-- list of mode / prefixes that should never be hooked by WhichKey
				-- this is mostly relevant for key maps that start with a native binding
				-- most people should not need to change this
				i = { "j", "k" },
				v = { "j", "k" },
			},
		},

		opts = {
			mode = "n", -- NORMAL mode
			prefix = "<leader>",
			buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
			silent = true, -- use `silent` when creating keymaps
			noremap = true, -- use `noremap` when creating keymaps
			nowait = true, -- use `nowait` when creating keymaps
		},

		vopts = {
			mode = "v", -- VISUAL mode
			prefix = "<leader>",
			buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
			silent = true, -- use `silent` when creating keymaps
			noremap = true, -- use `noremap` when creating keymaps
			nowait = true, -- use `nowait` when creating keymaps
		},

		-- NOTE: Prefer using : over <cmd> as the latter avoids going back in normal-mode.
		-- see https://neovim.io/doc/user/map.html#:map-cmd
		vmappings = {
			["/"] = { "<ESC><CMD>lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>", "Comment" },
		},

		mappings = {
			p = {
				name = "Packer",
				c = { "<cmd>PackerCompile<cr>", "Compile" },
				i = { "<cmd>PackerInstall<cr>", "Install" },
				s = { "<cmd>PackerSync<cr>", "Sync" },
				S = { "<cmd>PackerStatus<cr>", "Status" },
				u = { "<cmd>PackerUpdate<cr>", "Update" },
			},

			l = { "<cmd>Telescope buffers<cr>", "Find Buffer" },
			f = {
				name = "Find",
				F = { "<cmd>Telescope find_files<cr>", "Find File" },
				f = { "<cmd>Telescope git_files<cr>", "Find Git File" },
				r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
				b = { "<cmd>Telescope bookmarks<cr>", "Bookmarks" },
			},

			s = {
				name = "Search",
				b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
				h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
				H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
				m = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
				r = { "<cmd>Telescope registers<cr>", "Registers" },
				s = { "<cmd>Telescope live_grep<cr>", "Text" },
				u = { "<cmd>Telescope grep_string<cr>", "Text under cursor" },
				k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
				c = { "<cmd>Telescope commands<cr>", "Commands" },
				o = { "<cmd>Telescope lsp_document_symbols<cr>", "Symbols" },
				O = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },

				C = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
				p = {
					"<cmd>lua require('telescope.builtin.internal').colorscheme({enable_preview = true})<cr>",
					"Colorscheme with Preview",
				},
			},

			g = {
				name = "Git",
				j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
				k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
				L = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
				l = { "<cmd>call TmuxWindowCmd('fugitive', 'FORCE_COLOR=0 nvim -c :Gclog')<cr>", "Git log" },
				P = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
				p = { "<cmd>Git push<CR>", "Git push" },
				r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
				R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
				S = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
				s = {
					"<cmd>call TmuxWindowCmd('fugitive', 'FORCE_COLOR=0 nvim -c :Git -c 20wincmd_')<CR>",
					"Git status",
				},
				u = {
					"<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
					"Undo Stage Hunk",
				},
				t = { "<cmd>Telescope git_status<cr>", "Open changed file" },
				o = {
					"<cmd>Dispatch! gh repo view --web --branch $(git branch --show-current)<CR>",
					"Github Repo View",
				},
				O = {
					"<cmd>Dispatch! gh browse --branch $(git branch --show-current) %)<CR>",
					"Github Repo View File",
				},
				b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
				c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
				C = {
					"<cmd>Telescope git_bcommits<cr>",
					"Checkout commit(for current file)",
				},
				d = {
					"<cmd>Gitsigns diffthis HEAD<cr>",
					"Git Diff",
				},
			},

			-- LSP
			a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
			r = { vim.lsp.buf.rename, "Rename" },
			e = {
				name = "LSP",
				d = { "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", "Buffer Diagnostics" },
				w = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
				i = { "<cmd>LspInfo<cr>", "Info" },
				j = {
					vim.diagnostic.goto_next,
					"Next Diagnostic",
				},
				k = {
					vim.diagnostic.goto_prev,
					"Prev Diagnostic",
				},
				l = { vim.lsp.codelens.run, "CodeLens Action" },
				q = { vim.diagnostic.setloclist, "Quickfix" },
				e = { "<cmd>Telescope quickfix<cr>", "Telescope Quickfix" },
			},

			-- Copy relative/full path to system clipboard
			j = {
				f = {
					function()
						vim.cmd("let @+ = expand('%')")
					end,
					"Copy Relative Path",
				},
				F = {
					function()
						vim.cmd("let @+ = expand('%:p')")
					end,
					"Copy Full Path",
				},
			},

			h = {
				function()
					vim.cmd("DashWord")
				end,
				"DashWord",
			},
			H = {
				function()
					vim.cmd("Dash")
				end,
				"Dash",
			},

			n = {
				function()
					vim.cmd("NvimTreeToggle")
				end,
				"Explorer",
			},

			-- TODO: [d] pull most of dap from coc setup
		},
	}

	-- local mappings = conf.mappings
	-- mappings['d']['/'] = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" }

	return conf
end

M.setup = function()
	local status_ok, which_key = pcall(require, "which-key")
	if not status_ok then
		Log:error("Failed to load which-key")
	end

	local conf = config()
	which_key.setup(conf.setup)

	local opts = conf.opts
	local vopts = conf.vopts

	local mappings = conf.mappings
	local vmappings = conf.vmappings

	which_key.register(mappings, opts)
	which_key.register(vmappings, vopts)
end

return M
