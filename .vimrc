" packages

call plug#begin()
Plug 'fatih/vim-go'
Plug 'joukevandermaas/vim-ember-hbs'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'thoughtbot/vim-rspec'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dadbod'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-sensible'
Plug 'vim-airline/vim-airline'
Plug 'dbeniamine/cheat.sh-vim'
Plug 'tpope/vim-vinegar'
call plug#end()

" change cursor in insert mode
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" reset the cursor on start (for older versions of vim, usually not required)
augroup myCmds
au!
autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END

" set muh font for macvim
:set gfn=Menlo\ Regular:h16


" Turn off swapfiles
set noswapfile

" set line numbers
set number

" navigate away without saving
set hidden

" set leader key to space
nnoremap <SPACE> <Nop>
let mapleader=" "

" Tim Pope said so
set sessionoptions-=options

" FZF
set rtp+=/opt/homebrew/opt/fzf
nnoremap <silent> <leader><space> :GFiles<CR>
nnoremap <silent> <leader>j :Rg<CR>

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
	execute '!bundle exec rubocop '.path.force

	" if you want silent cops use the below instead
	" execute 'silent !rubocop '.path.force | execute 'redraw!'
endfunction

function! GetFilePath()
	:echo expand('%:p')
endfunction

function! RunTestFile()
	let path = expand('%:p')
	let file_name = expand('%:t:r')
	let extension = expand('%:e')
if extension == "go"
	:GoTest
elseif extension == "rb"
	execute "!bundle exec rspec ".path
else
	execute "!rake test"
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
else 
	echo "can't run that"
endif
endfunction


nnoremap <silent> <leader>e :cd %:p:h<CR>
nnoremap <silent> <leader>c :call RunCops()<CR>
nnoremap <silent> <leader>t :call RunTestFile()<CR>
nnoremap <silent> <leader>g :call RunTestUnderCursor()<CR>
nnoremap <silent> <leader>p :call GetFilePath()<CR>
nnoremap <silent> <leader>r :call RunFile()<CR>
nnoremap <silent> <leader>f :GoRename<CR>
nnoremap <silent> <leader>i :GoImport
nnoremap <silent> <leader>d :GoDoc<CR>
