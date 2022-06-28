local Log = require("sx.core.log")

local M = {}

local function use_small_dialog(ctx)
	if ctx.finder and ctx.finder.results and ctx.finder.results[1] then
		local fst = ctx.finder.results[1]
		local client_name = fst.value and fst.value.add and fst.value.add.client_name
		return client_name == "tsserver"
	end
	return false
end

local function is_table(t)
	return t ~= nil and type(t) == "table"
end

local function get_desired_width(ctx)
	local len = 0
	if ctx.finder and ctx.finder.results then
		for k, v in pairs(ctx.finder.results) do
			for k, v in pairs(v) do
				if is_table(v) then
					local add = v.add
					if add ~= nil then
						if add.client_name ~= nil then
							len = len + #add.client_name
						end
						if add.command_title ~= nil then
							len = len + #add.command_title
						end
					end
				end
			end
		end
	end
	return len 
end

local function config()
	local ok, actions = pcall(require, "telescope.actions")
	if not ok then
		return
	end
	return {
		defaults = {
			prompt_prefix = " ",
			selection_caret = " ",
			entry_prefix = "  ",
			initial_mode = "insert",
			selection_strategy = "reset",
			sorting_strategy = "descending",
			layout_strategy = "horizontal",
			layout_config = {
				width = 0.75,
				-- width = function(ctx, cols)
				-- 	local max = math.floor(cols * 0.75)
				-- 	if use_small_dialog(ctx) then
				-- 		return math.min(max, 80)
				-- 	end
				-- 	return max
				-- end,
				-- height = function(ctx, rows)
				-- 	local max = math.floor(rows * 0.75)
				-- 	if use_small_dialog(ctx) then
				-- 		return math.min(max, 30)
				-- 	end
				-- 	return max
				-- end,
				preview_cutoff = 120,
				horizontal = {
					preview_width = function(_, cols, _)
						if cols < 120 then
							return math.floor(cols * 0.5)
						end
						return math.floor(cols * 0.6)
					end,
					mirror = false,
				},
				vertical = { mirror = false },
			},
			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
				"--hidden",
				"--glob=!.git/",
			},
			mappings = {
				i = {
					["<C-n>"] = actions.move_selection_next,
					["<C-p>"] = actions.move_selection_previous,
					["<C-c>"] = actions.close,
					["<C-j>"] = actions.cycle_history_next,
					["<C-k>"] = actions.cycle_history_prev,
					["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
					["<CR>"] = actions.select_default,
				},
				n = {
					["<C-n>"] = actions.move_selection_next,
					["<C-p>"] = actions.move_selection_previous,
					["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
				},
			},
			file_ignore_patterns = {},
			path_display = { shorten = 5 },
			winblend = 0,
			border = {},
			borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
			color_devicons = true,
			set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
			pickers = {
				find_files = {
					hidden = true,
				},
				live_grep = {
					--@usage don't include the filename in the search results
					only_sort_text = true,
				},
			},
		},
		extensions = {
			fzf = {
				fuzzy = true, -- false will only do exact matching
				override_generic_sorter = true, -- override the generic sorter
				override_file_sorter = true, -- override the file sorter
				case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			},
			dash = {
				search_engine = "google",
			},
			bookmarks = {
				selected_browser = "chrome",
				url_open_command = "open",
				url_open_plugin = nil,
				full_path = true,
			},
			["ui-select"] = {
				require("telescope.themes").get_cursor({
					layout_config = {
						width = function(ctx, cols)
							local w = get_desired_width(ctx)
							return math.min(w, math.floor(cols * 0.75))
						end,
						height = 16,
					},
					borderchars = {
						prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
						results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
						preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					},
				}),
			},
		},
	}
end

function M.setup()
	local status_ok, telescope = pcall(require, "telescope")
	if not status_ok then
		Log:error("Failed to load telescope")
	end

	local previewers = require("telescope.previewers")
	local sorters = require("telescope.sorters")
	local actions = require("telescope.actions")
	local conf = config()

	local full_conf = vim.tbl_extend("keep", {
		file_previewer = previewers.vim_buffer_cat.new,
		grep_previewer = previewers.vim_buffer_vimgrep.new,
		qflist_previewer = previewers.vim_buffer_qflist.new,
		file_sorter = sorters.get_fuzzy_file,
		generic_sorter = sorters.get_generic_fuzzy_sorter,
		mappings = {
			i = {
				["<C-n>"] = actions.move_selection_next,
				["<C-p>"] = actions.move_selection_previous,
				["<C-c>"] = actions.close,
				["<C-j>"] = actions.cycle_history_next,
				["<C-k>"] = actions.cycle_history_prev,
				["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
				["<CR>"] = actions.select_default + actions.center,
			},
			n = {
				["<C-n>"] = actions.move_selection_next,
				["<C-p>"] = actions.move_selection_previous,
				["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
			},
		},
	}, conf)

	telescope.setup(full_conf)

	-- Register Extensions
	pcall(function()
		telescope.load_extension("notify")
		telescope.load_extension("fzf")
		telescope.load_extension("dash")
		telescope.load_extension("bookmarks")
		telescope.load_extension("gh")
		telescope.load_extension("ui-select")
	end)
end
M.setup()

return M
