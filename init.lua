local init_path = debug.getinfo(1, "S").source:sub(2)
local base_dir = init_path:match("(.*[/\\])"):sub(1, -2)

if not vim.tbl_contains(vim.opt.rtp:get(), base_dir) then
  vim.opt.rtp:append(base_dir)
end

require("sx.bootstrap"):init(base_dir)

require("sx.config"):init()

local plugins = require "sx.plugin"
require("sx.plugin-loader").load { plugins }

local Log = require "sx.core.log"
Log:debug "Starting ScratchVim"
