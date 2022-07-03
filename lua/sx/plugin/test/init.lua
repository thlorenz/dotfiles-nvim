local M = {}

function M.source()
	vim.cmd([[
nmap <silent> tn :TestNearest<CR>
nmap <silent> tf :TestFile<CR>
nmap <silent> ta :TestSuite<CR>
nmap <silent> tl :TestLast<CR>
nmap <silent> td :TestVisit<CR>

au FileType rust nmap <silent> tn :TestNearest --tests -- --nocapture<CR>
au FileType rust nmap <silent> tN :TestNearest --tests --features test-bpf -- --nocapture<CR>

let test#strategy = "dispatch"
]])
end

return M
