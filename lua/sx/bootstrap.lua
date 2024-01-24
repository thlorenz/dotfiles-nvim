local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
-- vim.notify(install_path)

if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

---Get the full path to `$SX_CACHE_DIR`
---@return string
function _G.get_cache_dir()
	local sx_cache_dir = os.getenv("SX_CACHE_DIR")
	if not sx_cache_dir then
		return vim.call("stdpath", "cache")
	end
	return sx_cache_dir
end

require("sx.config"):init()
