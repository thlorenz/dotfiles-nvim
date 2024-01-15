local kind_icons = {
	Class = " ",
	Color = " ",
	Constant = "ﲀ ",
	Constructor = " ",
	Enum = "練",
	EnumMember = " ",
	Event = " ",
	Field = " ",
	File = "",
	Folder = " ",
	Function = " ",
	Interface = "ﰮ ",
	Keyword = " ",
	Method = " ",
	Module = " ",
	Operator = "",
	Property = " ",
	Reference = " ",
	Snippet = " ",
	Struct = " ",
	Text = " ",
	TypeParameter = " ",
	Unit = "塞",
	Value = " ",
	Variable = " ",
}

local source_names = {
	cmp_ai = "(Bard)",
	nvim_lsp = "(LSP)",
	nvim_lua = "(API)",
	ultisnips = "(UltiSnips)",
	path = "(Path)",
	calc = "(Calc)",
	buffer = "(Buffer)",
	tmux = "(TMUX)",
}

local fields = { "kind", "abbr", "menu" }
local max_width = 0

local duplicates = {
	buffer = 1,
	path = 1,
	nvim_lsp = 0,
	luasnip = 1,
}
local duplicates_default = 0

local formatting = {
	fields = fields,
	max_width = max_width,
	kind_icons = kindIncons,
	source_names = source_names,
	duplicates = duplicates,
	duplicates_default = duplicates_default,

	format = function(entry, vim_item)
		local max_width = max_width
		if max_width ~= 0 and #vim_item.abbr > max_width then
			vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 1) .. "…"
		end
		vim_item.kind = kind_icons[vim_item.kind]
		vim_item.menu = source_names[entry.source.name]
		vim_item.dup = duplicates[entry.source.name] or duplicates_default
		return vim_item
	end,
}

return formatting
