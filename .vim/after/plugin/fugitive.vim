function! CreateFugitiveGrepKeyMappings() abort
	if !empty(FugitiveGitDir()) |
		nmap <Leader>8 :Ggrep -q <cword><CR>
		nmap <Leader><Leader>8 :Ggrep -w -q <cword><CR>
	endif
endfunction

autocmd BufReadPost * call CreateFugitiveGrepKeyMappings()

