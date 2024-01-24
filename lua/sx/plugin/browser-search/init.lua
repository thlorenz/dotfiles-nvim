local M = {}

M.setup = function()
	vim.g.browser_search_builtin_engines = {
		google = "https://google.com/search?q=%s",
		github = "https://github.com/search?q=%s",
		cratesio = "https://crates.io/search?q=%s",
		stackoverflow = "https://stackoverflow.com/search?q=%s",
		wikipedia = "https://en.wikipedia.org/wiki/%s",
		youtube = "https://www.youtube.com/results?search_query=%s&page=&utm_source=opensearch",
		translate = "https://translate.google.com/?sl=auto&tl=it&text=%s",
	}
	vim.g.browser_search_default_engine = "google"
end

return M
