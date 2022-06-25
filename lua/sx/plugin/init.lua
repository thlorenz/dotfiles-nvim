local Log = require "sx.core.log"

local packer_available, packer = pcall(require, "packer")
if not packer_available then
  Log:warn "skipping loading plugins until Packer is installed"
  return
end

packer.startup(function(use)
  use 'wbthomason/packer.nvim'

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

  -- Navigation
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icons
    },
    opt = true,
    cmd = { 'NvimTreeToggle' },
    config = function()
      require('sx.plugin.nvim-tree').setup()
    end,
  }

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
