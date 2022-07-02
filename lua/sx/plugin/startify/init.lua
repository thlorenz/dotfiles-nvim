local M = {}
M.setup = function()
	vim.cmd([[
    let g:startify_lists = [
          \ { 'type': 'sessions',  'header': ['   Sessions']       },
          \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
          \ { 'type': 'files',     'header': ['   MRU']            },
          \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
          \ { 'type': 'commands',  'header': ['   Commands']       },
          \ ]
    let g:startify_change_to_vcs_root = 1
    let g:startify_change_to_dir = 0
    let g:startify_session_before_save = [ 'silent! tabdo NvimTreeClose' ]
  ]])
end

return M
