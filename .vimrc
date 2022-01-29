" Turn off swapfiles
set noswapfile

" set line numbers
set number

" set leader key to space
nnoremap <SPACE> <Nop>
let mapleader=" "

" Tim Pope said so
set sessionoptions-=options

" FZF
set rtp+=/opt/homebrew/opt/fzf
nnoremap <silent> <leader><space> :GFiles<CR>
nnoremap <silent> <leader>j :Rg<CR>

" Change the cursor in insert mode bebbe
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

"COCVIM
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
" use return to select the suggestion
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

" my superawesome functions

function! RunCops()
	let path = expand('%:p')
	let force = ' -a'
	execute 'silent !rubocop '.path.force | execute 'redraw!'
endfunction

function! RunTestFile()
	let file_name = expand('%:t:r')
	let extension = expand('%:e')
if extension == "go"
	:GoTest
elseif extension == "js"
	execute "!npm test"
else
	let path = expand('%:p')
	execute "!rspec ". path
endif
endfunction

function! RunTestUnderCursor()
	let file_name = expand('%:t:r')
	let extension = expand('%:e')
if extension == "go"
	:GoTest
else
	if split(file_name, "_")[-1] == "spec"
		execute "!rspec ". file_name.".".extension.":".line('.')
	else
		execute "!rake test"
	endif
endif
endfunction

function! RunFile()
	let file_name = expand('%:t:r')
	let extension = expand('%:e')
if extension == "go"
	:GoRun
elseif extension == "rb"
	execute "!ruby"." ".file_name.".".extension
endif
endfunction


nnoremap <silent> <leader>e :cd %:p:h<CR>
nnoremap <silent> <leader>c :call RunCops()<CR>
nnoremap <silent> <leader>t :call RunTestFile()<CR>
nnoremap <silent> <leader>g :call RunTestUnderCursor()<CR>
nnoremap <silent> <leader>r :call RunFile()<CR>
nnoremap <silent> <leader>f :GoRename<CR>
nnoremap <silent> <leader>i :GoImport
nnoremap <silent> <leader>d :GoDoc<CR>
