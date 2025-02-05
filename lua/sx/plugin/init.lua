local Log = require("sx.core.log")

vim.env.PATH = vim.fn.stdpath("data")
	.. "/mason/bin"
	.. (is_windows and "; " or ":")
	.. vim.env.PATH

local packer_available, packer = pcall(require, "packer")
if not packer_available then
	Log:warn("skipping loading plugins until Packer is installed")
	return
end

packer.startup(function(use)
	use("wbthomason/packer.nvim")

	--
	-- Navigation
	--

	-- Tmux Integration
	use({
		"alexghergh/nvim-tmux-navigation",
		config = function()
			require("nvim-tmux-navigation").setup({
				disable_when_zoomed = true, -- defaults to false
				keybindings = {
					left = "<C-h>",
					down = "<C-j>",
					up = "<C-k>",
					right = "<C-l>",
				},
			})
		end,
	})
	-- use({ "christoomey/vim-tmux-runner" })

	-- Windows
	-- use({
	-- 	"mrjones2014/smart-splits.nvim",
	-- 	config = function()
	-- 		require("sx.plugin.smart-splits").setup()
	-- 	end,
	-- })

	use({ "camgraff/telescope-tmux.nvim" })
	use({
		"kyazdani42/nvim-tree.lua",
		requires = { "kyazdani42/nvim-web-devicons" },
		config = function()
			require("sx.plugin.nvim-tree").setup()
		end,
	})

	-- Buffers
	use("kazhala/close-buffers.nvim")

	-- Bookmarks
	vim.g.bookmark_save_per_working_dir = 1
	vim.g.bookmark_auto_save = 1

	use({ "MattesGroeger/vim-bookmarks" })
	use({ "tom-anders/telescope-vim-bookmarks.nvim" })

	-- Telescope
	use({
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("sx.plugin.telescope").setup()
		end,
	})
	-- Files
	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		requires = { "nvim-telescope/telescope.nvim" },
		run = "make",
	})

	-- Notifications
	use({
		"rcarriga/nvim-notify",
		config = function()
			require("sx.plugin.notify").setup()
		end,
		requires = { "nvim-telescope/telescope.nvim" },
	})
	-- ui-select
	-- https://github.com/nvim-telescope/telescope-ui-select.nvim
	use({
		"nvim-telescope/telescope-ui-select.nvim",
		requires = { "nvim-telescope/telescope.nvim" },
	})
	-- github
	-- https://github.com/nvim-telescope/telescope-github.nvim
	use({
		"nvim-telescope/telescope-github.nvim",
		requires = {
			"nvim-telescope/telescope.nvim",
		},
	})
	use("$HOME/dev/lua/nvim-plugins/telescope/telescope-playlist")
	use({
		"$HOME/dev/lua/nvim-plugins/tmuxrun/tmuxrun.nvim",
		config = function()
			require("sx.plugin.tmuxrun").setup()
		end,
	})

	-- dash
	use({
		"mrjones2014/dash.nvim",
		run = "make install",
	})
	-- debugging
	-- use({
	-- 	"nvim-telescope/telescope-dap.nvim",
	-- 	requires = {
	-- 		"nvim-telescope/telescope.nvim",
	-- 	},
	-- })

	--
	-- Tools
	--

	-- Git/Github

	use({
		"tpope/vim-fugitive",
		opt = true,
		cmd = {
			"G",
			"Git",
			"Gdiffsplit",
			"Gread",
			"Gwrite",
			"Ggrep",
			"GMove",
			"GDelete",
			"GBrowse",
			"GRemove",
			"GRename",
			"Glgrep",
			"Gclog",
			"GcLog",
			"Gclog",
			"Gllog",
			"Gedit",
		},
		ft = { "fugitive" },
	})

	-- use({
	-- 	"lewis6991/gitsigns.nvim",
	-- 	config = function()
	-- 		require("sx.plugin.gitsigns").setup()
	-- 	end,
	-- 	event = "BufRead",
	-- })

	-- use({
	-- 	"pwntester/octo.nvim",
	-- 	requires = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-telescope/telescope.nvim",
	-- 		"nvim-tree/nvim-web-devicons",
	-- 	},
	-- 	config = function()
	-- 		require("octo").setup()
	-- 	end,
	-- })

	-- Make and Quickfix
	require("sx.plugin.dispatch").source()
	use({
		"tpope/vim-dispatch",
		opt = true,
		cmd = { "Dispatch", "Make", "Focus", "Start" },
	})

	--
	-- Integration with External Tools
	--
	-- https://github.com/voldikss/vim-browser-search
	use({
		"voldikss/vim-browser-search",
		event = "VimEnter",
		config = function()
			require("sx.plugin.browser-search").setup()
		end,
	})

	-- Markdown Preview
	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	})

	-- Wakatime
	use("wakatime/vim-wakatime")

	-- VimWiki
	require("sx.plugin.vimwiki").preSetup()
	use("vimwiki/vimwiki")
	--
	-- Shortcuts
	--

	-- WhichKey
	use({
		"max397574/which-key.nvim",
		config = function()
			require("sx.plugin.which-key").setup()
		end,
		event = "BufWinEnter",
	})

	--
	-- Editing
	--

	-- Syntax
	use({
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("sx.plugin.treesitter").setup()
		end,
	})
	use({ "ron-rs/ron.vim" })
	use({ "rvmelkonian/move.vim" })

	use({
		"mhartington/formatter.nvim",
		config = function()
			require("sx.plugin.formatter").setup()
		end,
	})

	use({
		"godlygeek/tabular",
	})

	-- Substitution and renaming
	use({ "tpope/vim-abolish" })

	-- Multiple Cursors
	use({ "mg979/vim-visual-multi" })

	-- Surrounding
	use({ "tpope/vim-surround" })

	--
	-- AI
	--

	-- Copilot
	-- look into https://github.com/zbirenbaum/copilot.lua?
	vim.cmd([[
    highlight CopilotSuggestion guifg=#304d9f ctermfg=8
    let g:copilot_no_tab_map = v:true
    let g:copilot_filetypes = {
    \   '*': v:true,
    \   'xml': v:false,
    \ }

    imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
    imap <silent><script><nowait><expr> <C-\> copilot#Dismiss() . "\<C-\>"
    imap <C-]> <Plug>(copilot-next)
    imap <C-[> <Plug>(copilot-previous)
  ]])
	use({
		"github/copilot.vim",
		config = function()
			vim.cmd([[
        highlight CopilotSuggestion guifg=#304d9f ctermfg=8
        imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
        let g:copilot_no_tab_map = v:true
      ]])
		end,
	})

	-- Cody
	-- works, but has no project context
	use({
		"sourcegraph/sg.nvim",
		run = "nvim -l build/init.lua",
		config = function()
			require("sg").setup()
		end,
	})

	-- local copilot_cmd = [[
	--   highlight CopilotSuggestion guifg=#304D9F ctermfg=8
	--   imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
	--   let g:copilot_no_tab_map = v:true
	-- ]]
	-- vim.cmd(copilot_cmd)
	-- use({
	-- 	"github/copilot.vim",
	-- 	config = function()
	-- 		vim.cmd(copilot_cmd)
	-- 	end,
	-- })

	-- vim.cmd([[
	--   highlight CopilotSuggestion guifg=#3333DD ctermfg=8
	-- ]])
	-- use({
	-- 	"zbirenbaum/copilot.lua",
	-- 	event = "InsertEnter",
	-- 	config = function()
	-- 		vim.schedule(function()
	-- 			require("copilot").setup({
	-- 				panel = {
	-- 					enabled = true,
	-- 					auto_refresh = false,
	-- 					keymap = {
	-- 						jump_prev = "[[",
	-- 						jump_next = "]]",
	-- 						accept = "<CR>",
	-- 						refresh = "gr",
	-- 						open = "<M-CR>",
	-- 					},
	-- 				},
	-- 				suggestion = {
	-- 					enabled = true,
	-- 					auto_trigger = false,
	-- 					debounce = 75,
	-- 					keymap = {
	-- 						accept = "<C-J>",
	-- 						next = "<C-]>",
	-- 						prev = "<C-[>",
	-- 						dismiss = "<C-\\>",
	-- 					},
	-- 				},
	-- 				filetypes = {
	-- 					yaml = false,
	-- 					markdown = false,
	-- 					help = false,
	-- 					gitcommit = false,
	-- 					gitrebase = false,
	-- 					hgcommit = false,
	-- 					svn = false,
	-- 					cvs = false,
	-- 					["."] = false,
	-- 				},
	-- 				copilot_node_command = "node",
	-- 				plugin_manager_path = vim.fn.stdpath("data")
	-- 					.. "/site/pack/packer",
	-- 				server_opts_overrides = {},
	-- 			})
	-- 		end)
	-- 	end,
	-- })

	-- use({
	-- 	"zbirenbaum/copilot-cmp",
	-- 	after = { "copilot.lua" },
	-- 	config = function()
	-- 		require("copilot_cmp").setup()
	-- 	end,
	-- })

	-- Clipboard
	use({
		"AckslD/nvim-neoclip.lua",
		requires = {
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			-- https://github.com/AckslD/nvim-neoclip.lua
			require("neoclip").setup()
		end,
	})

	-- LSP/CMP
	require("sx.plugin.lsp").source()
	use({
		"neovim/nvim-lspconfig",
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-path",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-buffer",
			"quangnguyen30192/cmp-nvim-ultisnips",
			"SirVer/ultisnips",
		},
		config = function()
			require("sx.plugin.cmp").setup()
		end,
	})
	use({
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = "BufReadPre",
		config = function()
			require("fidget").setup({})
		end,
	})

	-- use({ "antoinemadec/FixCursorHold.nvim" }) -- Needed while issue https://github.com/neovim/neovim/issues/12587 is still open

	-- Theme
	require("sx.plugin.colorscheme").source()
	use({
		"challenger-deep-theme/vim",
		as = "challenger_deep",
		config = function()
			vim.cmd("colorscheme challenger_deep")
		end,
	})

	-- https://github.com/folke/twilight.nvim
	use({
		"folke/twilight.nvim",
		opt = true,
		cmd = {
			"Twilight",
			"TwilightEnable",
			"TwilightDisable",
		},
		config = function()
			require("sx.plugin.twilight").setup()
		end,
	})

	-- https://github.com/bash-lsp/bash-language-server
	-- npm i -g bash-language-server
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "sh",
		callback = function()
			vim.lsp.start({
				name = "bash-language-server",
				cmd = { "bash-language-server", "start" },
			})
		end,
	})
	--
	-- Startup
	--

	use({
		"mhinz/vim-startify",
		config = function()
			require("sx.plugin.startify").setup()
		end,
	})

	--
	-- Debugging/Testing
	--
	-- Temporarily disabled as latest version fails to load
	-- use({
	-- 	"mfussenegger/nvim-dap",
	-- 	opt = true,
	-- 	event = "BufReadPre",
	-- 	module = { "dap" },
	-- 	wants = { "nvim-dap-virtual-text", "nvim-dap-ui" },
	-- 	requires = {
	-- 		"theHamsta/nvim-dap-virtual-text",
	-- 		"rcarriga/nvim-dap-ui",
	-- 		{ "jbyuki/one-small-step-for-vimkind", module = "osv" },
	-- 	},
	-- 	config = function()
	-- 		require("sx.plugin.dap").setup()
	-- 	end,
	-- })

	require("sx.plugin.test").source()
	-- use({ "vim-test/vim-test" }) -- , requires = { "christoomey/vim-tmux-runner" } })
	use("$HOME/dev/lua/nvim-plugins/tmuxrun/vim-test/")

	--
	-- Language Support
	--

	-- Hex Editing
	use({
		"RaafatTurki/hex.nvim",
		config = function()
			require("hex").setup()
		end,
	})

	-- Manage language servers with mason
	-- MasonInstall rust-analyzer codelldb
	use({
		"williamboman/mason.nvim",
		requires = "williamboman/mason-lspconfig.nvim",
		config = function()
			require("sx.plugin.mason").setup()
		end,
	})

	-- Rust
	-- vim.g.rustaceanvim = {
	-- 	tools = {},
	-- }
	-- use({
	-- 	"mrcjkb/rustaceanvim",
	-- 	version = "^4", -- Recommended
	-- })

	use({
		"nvim-neotest/neotest",
		requires = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"mrcjkb/rustaceanvim",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("rustaceanvim.neotest"),
				},
			})
		end,
	})

	-- Zig
	-- require 'lspconfig'.zls.setup{}

	-- Go
	use({ "ray-x/go.nvim" })

	if packer_bootstrap then
		packer.sync()
	end

	-- Dart/Flutter
	use({ "dart-lang/dart-vim-plugin" })
	use({ "thosakwe/vim-flutter" })
end)
