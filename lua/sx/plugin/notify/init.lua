local M = {}

local Log = require("sx.core.log")

local function config()
	local stages_util = require("notify.stages.util")
	local slide = {
		function(state)
			local next_height = state.message.height + 2
			local next_row = stages_util.available_slot(
				state.open_windows,
				next_height,
				stages_util.DIRECTION.BOTTOM_UP
			)
			if not next_row then
				return nil
			end
			return {
				relative = "editor",
				anchor = "NE",
				width = 1,
				height = state.message.height,
				col = vim.opt.columns:get(),
				row = next_row,
				border = "rounded",
				style = "minimal",
			}
		end,
		function(state)
			return {
				width = { state.message.width, frequency = 2 },
				col = { vim.opt.columns:get() },
			}
		end,
		function()
			return {
				col = { vim.opt.columns:get() },
				time = true,
			}
		end,
		function()
			return {
				width = {
					1,
					frequency = 2.5,
					damping = 0.9,
					complete = function(cur_width)
						return cur_width < 2
					end,
				},
				col = { vim.opt.columns:get() },
			}
		end,
	}

	local fade = {
		function(state)
			local next_height = state.message.height + 2
			local next_row = stages_util.available_slot(
				state.open_windows,
				next_height,
				stages_util.DIRECTION.BOTTOM_UP
			)
			if not next_row then
				return nil
			end
			return {
				relative = "editor",
				anchor = "NE",
				width = state.message.width,
				height = state.message.height,
				col = vim.opt.columns:get(),
				row = next_row,
				border = "rounded",
				style = "minimal",
				opacity = 0,
			}
		end,
		function()
			return {
				opacity = { 100 },
				col = { vim.opt.columns:get() },
			}
		end,
		function()
			return {
				col = { vim.opt.columns:get() },
				time = true,
			}
		end,
		function()
			return {
				opacity = {
					0,
					frequency = 2,
					complete = function(cur_opacity)
						return cur_opacity <= 4
					end,
				},
				col = { vim.opt.columns:get() },
			}
		end,
	}

	return {
		---@usage Animation style one of { "fade", "slide", "fade_in_slide_out", "static" }
		stages = fade,

		---@usage Function called when a new window is opened, use for changing win settings/config
		on_open = nil,

		---@usage Function called when a window is closed
		on_close = nil,

		---@usage timeout for notifications in ms, default 5000
		timeout = 5000,

		-- Render function for notifications. See notify-render()
		render = "minimal",

		---@usage highlight behind the window for stages that change opacity
		background_colour = "Normal",

		---@usage minimum width for notification windows
		minimum_width = 50,

		---@usage Icons for the different levels
		icons = {
			ERROR = "",
			WARN = "",
			INFO = "",
			DEBUG = "",
			TRACE = "✎",
		},
	}
end

function M.setup()
	if #vim.api.nvim_list_uis() == 0 then
		Log:debug("headless mode detected, skipping running setup for notify")
		return
	end

	-- https://github.com/rcarriga/nvim-notify
	local status_ok, notify = pcall(require, "notify")
	if not status_ok then
		Log:error("Failed to load notify")
	end

	local conf = config()
	notify.setup(conf)
	vim.notify = notify
	Log:configure_notifications(notify)
end

return M
