" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

runtime! debian.vim

" Vim will load $VIMRUNTIME/defaults.vim if the user does not have a vimrc.
" This happens after /etc/vim/vimrc(.local) are loaded, so it will override
" any settings in these files.
" If you don't want that to happen, uncomment the below line to prevent
" defaults.vim from being loaded.
" let g:skip_defaults_vim = 1

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
"filetype plugin indent on

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd		" Show (partial) command in status line.
"set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden		" Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

inoremap ( ()<ESC>i
inoremap [ []<ESC>i
"inoremap { {}<ESC>i<ENTER><TAB><ENTER>
"inoremap { {<CR>}<ESC>O
inoremap { {}<ESC>i<CR><TAB><ESC>V<O
"inoremap < <><ESC>i
inoremap ' ''<ESC>i
inoremap " ""<ESC>i
set nu               "设置显示行号
set tabstop=4        "设置tab健的长度为4
set ruler            "设置标尺
set ai               "设置文本高亮
set autoindent       "设置自动缩进（与上一行的缩进相同）
"set mouse=a"

"设置跳出自动补全的括号"
func SkipPair()  
    if getline('.')[col('.') - 1] == ')' || getline('.')[col('.') - 1] == ']' || getline('.')[col('.') - 1] == '"' || getline('.')[col('.') - 1] == "'" || getline('.')[col('.') - 1] == '}'  
        return "\<ESC>la"  
    else  
        return "\t"  
    endif  
endfunc  
" 将tab键绑定为跳出括号  
inoremap <TAB> <c-r>=SkipPair()<CR>
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4

"设置自动删除前后括号"
" 按退格键时判断当前光标前一个字符，如果是左括号，则删除对应的右括号以及括号中间的内容
function! RemovePairs()
let l:line = getline(".")
let l:previous_char = l:line[col(".")-1] " 取得当前光标前一个字符
 
if index(["(", "[", "{"], l:previous_char) != -1
let l:original_pos = getpos(".")
execute "normal %"
let l:new_pos = getpos(".")
 
" 如果没有匹配的右括号
if l:original_pos == l:new_pos
execute "normal! a\<BS>"
return
end
 
let l:line2 = getline(".")
if len(l:line2) == col(".")
" 如果右括号是当前行最后一个字符
execute "normal! v%xa"
else
" 如果右括号不是当前行最后一个字符
execute "normal! v%xi"
end
 
else
execute "normal! a\<BS>"
end
endfunction
" 用退格键删除一个左括号时同时删除对应的右括号
inoremap <BS> <ESC>:call RemovePairs()<CR>a
" 输入一个字符时，如果下一个字符也是括号，则删除它，避免出现重复字符
function! RemoveNextDoubleChar(char)
let l:line = getline(".")
let l:next_char = l:line[col(".")] " 取得当前光标后一个字符

if a:char == l:next_char
execute "normal! l"
else
execute "normal! i" . a:char . ""
end
endfunction
inoremap ) <ESC>:call RemoveNextDoubleChar(')')<CR>a
inoremap ] <ESC>:call RemoveNextDoubleChar(']')<CR>a
inoremap } <ESC>:call RemoveNextDoubleChar('}')<CR>a
