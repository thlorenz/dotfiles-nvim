local Log = require("sx.core.log")

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

	use({
		"kyazdani42/nvim-tree.lua",
		requires = {
			"kyazdani42/nvim-web-devicons", -- optional, for file icons
		},
		opt = true,
		cmd = { "NvimTreeToggle" },
		config = function()
			require("sx.plugin.nvim-tree").setup()
		end,
	})

	--
	-- Telescope
	--
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
	-- dash
	use({
		"mrjones2014/dash.nvim",
		run = "make install",
	})
	-- browser bookmarks
	use({ "dhruvmanila/telescope-bookmarks.nvim" })
	-- debugging
	use({
		"nvim-telescope/telescope-dap.nvim",
		requires = {
			"nvim-telescope/telescope.nvim",
		},
	})

	--
	-- Tools
	--

	-- Git

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
			"Gedit",
		},
		ft = { "fugitive" },
	})
	use({ "skanehira/gh.vim", opt = true, cmd = { "gh" } })

	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("sx.plugin.gitsigns").setup()
		end,
		event = "BufRead",
	})

	-- Make and Quickfix
	require("sx.plugin.dispatch").source()
	use({ "tpope/vim-dispatch", opt = true, cmd = { "Dispatch", "Make", "Focus", "Start" } })

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

	use({
		"mhartington/formatter.nvim",
		config = function()
			require("sx.plugin.formatter").setup()
		end,
	})

	-- LSP/CMP
	use({
		"neovim/nvim-lspconfig",
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-buffer",
			"quangnguyen30192/cmp-nvim-ultisnips",
			"SirVer/ultisnips",
		},
		config = function()
			require("sx.plugin.cmp").setup()
		end,
	})

	use({ "antoinemadec/FixCursorHold.nvim" }) -- Needed while issue https://github.com/neovim/neovim/issues/12587 is still open

	-- Theme
	require("sx.plugin.colorscheme").source()
	use({
		"challenger-deep-theme/vim",
		as = "challenger_deep",
		config = function()
			vim.cmd("colorscheme challenger_deep")
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
	-- Debugging
	--
	use({
		"mfussenegger/nvim-dap",
		opt = true,
		event = "BufReadPre",
		module = { "dap" },
		wants = { "nvim-dap-virtual-text", "nvim-dap-ui" },
		requires = {
			"theHamsta/nvim-dap-virtual-text",
			"rcarriga/nvim-dap-ui",
			{ "jbyuki/one-small-step-for-vimkind", module = "osv" },
		},
		config = function()
			require("sx.plugin.dap").setup()
		end,
	})

	--
	-- Language Support
	--

	-- Rust
	use({
		"simrat39/rust-tools.nvim",
		requires = { "nvim-lua/plenary.nvim", "rust-lang/rust.vim" },
		module = "rust-tools",
		ft = { "rust" },
		config = function()
			require("sx.plugin.rust-tools").setup()
		end,
	})

	if packer_bootstrap then
		packer.sync()
	end
end)
