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

" let test#strategy = "dispatch"
" let test#strategy = "neovim"
" let test#strategy = 'iterm'
" let test#strategy = 'vtr'
let test#strategy = 'tmuxrun'
]])
end

return M
