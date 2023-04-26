local M = {}

function M.preSetup()
	vim.cmd([[
    let g:vimwiki_list = [{'path': '~/.wiki', 'syntax': 'markdown', 'ext': '.md'}]
    let g:vimwiki_ext2syntax =  { '.md': 'markdown', '.markdown': 'markdown' }
    let g:vimwiki_markdown_link_ext = 1
    let g:vimwiki_global_ext=0
    au FileType vimwiki nmap <leader>tl <Plug>VimwikiToggleListItem
    au FileType vimwiki vmap <leader>tl <Plug>VimwikiToggleListItem
    au BufRead,BufNewFile *.md set filetype=markdown conceallevel=0
  ]])
end

return M
