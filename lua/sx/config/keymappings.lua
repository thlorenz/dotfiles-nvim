local M = {}
local Log = require("sx.core.log")

local generic_opts_any = { noremap = true, silent = true }

local generic_opts = {
	insert_mode = generic_opts_any,
	normal_mode = generic_opts_any,
	visual_mode = generic_opts_any,
	visual_block_mode = generic_opts_any,
	command_mode = generic_opts_any,
	term_mode = { silent = true },
}

local mode_adapters = {
	insert_mode = "i",
	normal_mode = "n",
	term_mode = "t",
	visual_mode = "v",
	visual_block_mode = "x",
	command_mode = "c",
}

---@class Keys
---@field insert_mode table
---@field normal_mode table
---@field terminal_mode table
---@field visual_mode table
---@field visual_block_mode table
---@field command_mode table

local function config()
	local defaults = {
		insert_mode = {
			-- 'jk' for quitting insert mode
			["jk"] = "<ESC>",
			-- 'kj' for quitting insert mode
			["kj"] = "<ESC>",
			-- 'jj' for quitting insert mode
			["jj"] = "<ESC>",
		},

		normal_mode = {
			-- Better window movement
			["<C-h>"] = "<C-w>h",
			["<C-j>"] = "<C-w>j",
			["<C-k>"] = "<C-w>k",
			["<C-l>"] = "<C-w>l",

			-- Resize with arrows
			["<C-Up>"] = ":resize -2<CR>",
			["<C-Down>"] = ":resize +2<CR>",
			["<C-Left>"] = ":vertical resize -2<CR>",
			["<C-Right>"] = ":vertical resize +2<CR>",

			-- QuickFix
			["]q"] = ":cnext<CR>",
			["[q"] = ":cprev<CR>",
			["cc"] = ":call QuickFixToggle()<CR>",

			["]g"] = vim.diagnostic.goto_next,
		},

		term_mode = {
			-- Terminal window navigation
			["<C-h>"] = "<C-\\><C-N><C-w>h",
			["<C-j>"] = "<C-\\><C-N><C-w>j",
			["<C-k>"] = "<C-\\><C-N><C-w>k",
			["<C-l>"] = "<C-\\><C-N><C-w>l",
		},

		visual_mode = {},

		visual_block_mode = {},

		command_mode = {
			-- navigate tab completion with <c-j> and <c-k>
			-- runs conditionally
			["<C-j>"] = { 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true } },
			["<C-k>"] = { 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true } },
		},
	}

	if vim.fn.has("mac") == 1 then
		defaults.normal_mode["<A-Up>"] = defaults.normal_mode["<C-Up>"]
		defaults.normal_mode["<A-Down>"] = defaults.normal_mode["<C-Down>"]
		defaults.normal_mode["<A-Left>"] = defaults.normal_mode["<C-Left>"]
		defaults.normal_mode["<A-Right>"] = defaults.normal_mode["<C-Right>"]
		Log:debug("Activated mac keymappings")
	end

	return defaults
end

--
-- Set key mappings individually
-- @param mode The keymap mode, can be one of the keys of mode_adapters
-- @param key The key of keymap
-- @param val Can be form as a mapping or tuple of mapping and user defined opt
function M.set_keymaps(mode, key, val)
	local opt = generic_opts[mode] or generic_opts_any
	if type(val) == "table" then
		opt = val[2]
		val = val[1]
	end
	if val then
		vim.keymap.set(mode, key, val, opt)
	else
		pcall(vim.api.nvim_del_keymap, mode, key)
	end
end

-- Load key mappings for a given mode
-- @param mode The keymap mode, can be one of the keys of mode_adapters
-- @param keymaps The list of key mappings
function M.load_mode(mode, keymaps)
	mode = mode_adapters[mode] or mode
	for k, v in pairs(keymaps) do
		M.set_keymaps(mode, k, v)
	end
end

-- Load key mappings for all provided modes
-- @param keymaps A list of key mappings for each mode
function M.load(keymaps)
	keymaps = keymaps or {}
	for mode, mapping in pairs(keymaps) do
		M.load_mode(mode, mapping)
	end
end

function M.setup()
	M.load(config())
end

return M
