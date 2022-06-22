local M = {}

if vim.fn.has "nvim-0.7" ~= 1 then
  vim.notify("Please upgrade your Neovim base installation. ScratchVim requires v0.7+", vim.log.levels.WARN)
  vim.wait(5000, function()
    return false
  end)
  vim.cmd "cquit"
end

local uv = vim.loop
local path_sep = uv.os_uname().version:match "Windows" and "\\" or "/"
local in_headless = #vim.api.nvim_list_uis() == 0

---Join path segments that were passed as input
---@return string
function _G.join_paths(...)
  local result = table.concat({ ... }, path_sep)
  return result
end

---Require a module in protected mode without relying on its cached value
---@param module string
---@return any
function _G.require_clean(module)
  package.loaded[module] = nil
  _G[module] = nil
  local _, requested = pcall(require, module)
  return requested
end

---Get the full path to `$SCRATCHVIM_RUNTIME_DIR`
---@return string
function _G.get_runtime_dir()
  local sx_runtime_dir = os.getenv "SCRATCHVIM_RUNTIME_DIR"
  if not sx_runtime_dir then
    -- when nvim is used directly
    return vim.call("stdpath", "data")
  end
  return sx_runtime_dir
end

---Get the full path to `$SCRATCHVIM_CONFIG_DIR`
---@return string
function _G.get_config_dir()
  local sx_config_dir = os.getenv "SCRATCHVIM_CONFIG_DIR"
  if not sx_config_dir then
    return vim.call("stdpath", "config")
  end
  return sx_config_dir
end

---Get the full path to `$SCRATCHVIM_CACHE_DIR`
---@return string
function _G.get_cache_dir()
  local sx_cache_dir = os.getenv "SCRATCHVIM_CACHE_DIR"
  if not sx_cache_dir then
    return vim.call("stdpath", "cache")
  end
  return sx_cache_dir
end

---Initialize the `&runtimepath` variables and prepare for startup
---@return table
function M:init(base_dir)
  self.runtime_dir = get_runtime_dir()
  self.config_dir = get_config_dir()
  self.cache_dir = get_cache_dir()
  self.pack_dir = join_paths(self.runtime_dir, "site", "pack")
  self.packer_install_dir = join_paths(self.runtime_dir, "site", "pack", "packer", "start", "packer.nvim")
  self.packer_cache_path = join_paths(self.config_dir, "plugin", "packer_compiled.lua")

  ---@meta overridden to use SCRATCHVIM_CACHE_DIR instead, since a lot of plugins call this function interally
  ---NOTE: changes to "data" are currently unstable, see #2507
  vim.fn.stdpath = function(what)
    if what == "cache" then
      return _G.get_cache_dir()
    end
    return vim.call("stdpath", what)
  end

  ---Get the full path to ScratchVim's base directory
  ---@return string
  function _G.get_sx_base_dir()
    return base_dir
  end

  if os.getenv "SCRATCHVIM_RUNTIME_DIR" then
    vim.opt.rtp:remove(join_paths(vim.call("stdpath", "data"), "site"))
    vim.opt.rtp:remove(join_paths(vim.call("stdpath", "data"), "site", "after"))
    vim.opt.rtp:prepend(join_paths(self.runtime_dir, "site"))
    vim.opt.rtp:append(join_paths(self.runtime_dir, "site", "after"))

    vim.opt.rtp:remove(vim.call("stdpath", "config"))
    vim.opt.rtp:remove(join_paths(vim.call("stdpath", "config"), "after"))
    vim.opt.rtp:prepend(self.config_dir)
    vim.opt.rtp:append(join_paths(self.config_dir, "after"))
    -- TODO: we need something like this: vim.opt.packpath = vim.opt.rtp

    vim.cmd [[let &packpath = &runtimepath]]
  end

  require("sx.config"):init()

  require("sx.plugin-loader").init {
    package_root = self.pack_dir,
    install_path = self.packer_install_dir,
  }

  return self
end

return M
