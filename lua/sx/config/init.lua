local M = {}

--- Initialize sx default configuration and variables
function M:init()
  ---@diagnostic disable-next-line: lowercase-global
  sx = vim.deepcopy(require "sx.config.defaults")

  require("sx.config.keymappings").setup()

  local settings = require "sx.config.settings"
  settings.load_defaults()

end

return M
