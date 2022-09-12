local M = {}

function M.setup()
	local status_ok, tmuxrun = pcall(require, "tmuxrun")
	if not status_ok then
		Log:error("Failed to load tmuxrun")
	end
	tmuxrun.setup({
		newPaneInitTime = 800,
		saveFile = tmuxrun.SaveFile.All,
	})
end

return M
