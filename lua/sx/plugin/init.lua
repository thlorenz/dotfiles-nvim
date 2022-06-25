local Log = require "sx.core.log"

local packer_available, packer = pcall(require, "packer")
if not packer_available then
  Log:warn "skipping loading plugins until Packer is installed"
  return
end

packer.startup(function(use)
  use 'wbthomason/packer.nvim'

  --
  -- Navigation
  --
  
  -- Tmux Integration
  use {
    'alexghergh/nvim-tmux-navigation',
    config = function()
      require 'nvim-tmux-navigation'.setup {
        disable_when_zoomed = true, -- defaults to false
        keybindings = {
          left = "<C-h>",
          down = "<C-j>",
          up = "<C-k>",
          right = "<C-l>",
        }
      }
    end
  }

  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icons
    },
    opt = true,
    cmd = { 'NvimTreeToggle' },
    config = function() require('sx.plugin.nvim-tree').setup() end
  }

  -- Telescope
  use {
    "nvim-telescope/telescope.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function() require('sx.plugin.telescope').setup() end
  }
  use {
    "nvim-telescope/telescope-fzf-native.nvim",
    requires = { "nvim-telescope/telescope.nvim" },
    run = "make",
  }
  use {
    "rcarriga/nvim-notify",
    config = function()
      require("sx.plugin.notify").setup()
    end,
    requires = { "nvim-telescope/telescope.nvim" },
  }

  --
  -- Tools
  --

  -- Git

  use {
    'tpope/vim-fugitive',
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
      "Gedit"
    },
    ft = { "fugitive" }
  }
  use { 'skanehira/gh.vim', opt = true, cmd = { 'gh' } }

  use {
    "lewis6991/gitsigns.nvim",
    config = function() require("sx.plugin.gitsigns").setup() end,
    event = "BufRead",
  }

  -- Make and Quickfix
  require("sx.plugin.dispatch").source()
  use { 'tpope/vim-dispatch',
    opt = true,
    cmd = { 'Dispatch', 'Make', 'Focus', 'Start' },
  }

  --
  -- Shortcuts
  --

  -- WhichKey
  use {
    "max397574/which-key.nvim",
    config = function() require("sx.plugin.which-key").setup() end,
    event = "BufWinEnter"
  }

  --
  -- Editing
  --
  use {
    "nvim-treesitter/nvim-treesitter",
    config = function() require("sx.plugin.treesitter").setup() end,
  }

  -- LSP

  use { "neovim/nvim-lspconfig" }
  -- { "tamago324/nlsp-settings.nvim" },
  -- { "jose-elias-alvarez/null-ls.nvim", },
  use { "williamboman/nvim-lsp-installer" }
  use { 
    'mhartington/formatter.nvim',
    config = function() require("sx.plugin.formatter").setup() end,
  }

  use { "antoinemadec/FixCursorHold.nvim" } -- Needed while issue https://github.com/neovim/neovim/issues/12587 is still open

  -- Theme
  use {
    'challenger-deep-theme/vim',
    as = 'challenger_deep',
    config = function() vim.cmd 'colorscheme challenger_deep' end
  }

  if packer_bootstrap then
    packer.sync()
  end
end)
