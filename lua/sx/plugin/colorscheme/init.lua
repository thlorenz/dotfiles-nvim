local M = {}

M.source = function()
	-- These theme overrides need to run after all is setup so we wait a few msecs as otherwise
	-- the overrides don't properly apply
	local timer = vim.loop.new_timer()
	vim.loop.new_timer()
	timer:start(
		200,
		0,
		vim.schedule_wrap(function()
			timer:close()
			vim.cmd([[
        highlight DiagnosticError ctermfg=1 guifg=Gray
      ]])
		end)
	)
end

return M
