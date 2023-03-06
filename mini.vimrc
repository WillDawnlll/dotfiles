call plug#begin('~/.vim/plugged')
    Plug 'sainnhe/sonokai'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'jackguo380/vim-lsp-cxx-highlight'
    Plug 'liuchengxu/vista.vim'
    Plug 'skywind3000/vim-quickui'
    Plug 'inkarkat/vim-ingo-library' "mark 插件的依赖
    Plug 'inkarkat/vim-mark'
    Plug 'easymotion/vim-easymotion'
    Plug 'junegunn/vim-easy-align'
    Plug 'yianwillis/vimcdoc'
    Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
    Plug 'itchyny/lightline.vim'
    Plug 'rhysd/vim-clang-format'
    Plug 'luochen1990/rainbow'

    "Plug 'sheerun/vim-polyglot' " 各语言语法高亮规则  缩进规则
    "Plug 'yuratomo/w3m.vim'
call plug#end()

" rainbow
let g:rainbow_active = 1
let g:rainbow_conf = { 'separately': { 'cmake': 0, } }

if has('termguicolors')
set termguicolors
endif
let g:mapleader ="\<space>"

let g:sonokai_style = 'maia'
let g:sonokai_enable_italic = 1
let g:sonokai_disable_italic_comment = 1
colorscheme sonokai
syntax on

set sidescroll=80
set noswapfile
set nobackup
set nowritebackup
set noundofile
set laststatus=2
"set updatetime=300

set enc=utf-8
set fenc=utf8
set lcs=tab:>_,trail:-,extends:>,precedes:<,nbsp:+,space:·,eol:$
set nolist
set hlsearch
set incsearch
set ts=4
set sw=4
set et
set nu
set relativenumber
set sb
set spr
set vb
set report       =0
set synmaxcol    =200
set foldlevelstart=0
set foldmethod=marker
set completeopt=menu,menuone
set cino=(0
set clipboard=unnamedplus
set display=lastline

set cursorline
"set cursorcolumn
hi Cursor  cterm=reverse gui=reverse
hi CursorLine   guibg=black ctermbg=black
"hi CursorColumn guibg=black ctermbg=black

hi visual  gui=reverse cterm=reverse
hi Search  gui=bold guifg=#000000 guibg=#FD971f
"hi Search  cterm=bold ctermfg=black ctermbg=yellow

let g:vista_highlight_whole_line = 1
let g:vista_stay_on_open = 0
let g:vista_update_on_text_changed = 1
let g:vista_echo_cursor_strategy = 'floating_win'
let g:vista#executives = ['coc','ctags','vim_lsp']
let g:vista_default_executive = 'coc'
let g:vista_executive_for = {'typescript': 'coc', 'go': 'coc', 'c': 'coc', 'javascript': 'coc', 'html': 'coc', 'rust': 'coc', 'cpp': 'coc', 'css': 'coc', 'python': 'coc','vim':'ctags','java':'coc'}
let g:vista_sidebar_position = 'vertical topleft'
let g:vista_sidebar_width = 30
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
"  Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
let  g:vista#renderer#enable_icon  =  0

"  The default icons can't be suitable for all the filetypes, you can extend it as you wish.
let g:vista#renderer#icons = {
		\   "function": "\uf794",
		\   "variable": "\uf71b",
		\  }
let g:vista_fzf_preview = ['right:50%']
nmap  <leader>v :Vista focus<cr>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> gh :call <SID>show_documentation()<CR>

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')."@cn"
    elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
    endif
endfunction

function! DictSearch(word)
    let rg="rg "
    let ecdict="~/ecdict.csv"
    let opts = {"close":"button", "title":"DictSearch: <".a:word.">","col":6+col("."),"line":winline()+2}
    let cmd_str=rg.' -i "^'.a:word.'," '.ecdict
    let result_str=system(cmd_str)
    let result_csv=split(result_str,'\n')
    let content=[]
    if type(result_csv) == type("")
        let result_csv=[result_csv]
    elseif type(result_csv) != type([])
        let content =["csv result error, not string or list"]
    endif
    "echo type(result_csv)
    for i in result_csv
        let wd = matchstr(i,"^\\w\\+,")
        let content += [wd]
        let i_ = matchstr(i,",.\\\{,8\}[\u4E00-\u9FA5].*")
        "let i_ = substitute(i_,"\\\\n"," ","g")
        let i_ = substitute(i_,','," ","g")
        let i_ = substitute(i_,'"',"","g")
        let i_ = substitute(i_," 0","","g")
        let s=split(i_."\\n ","\\\\n")
        let content += s
        let content +=[""]
    endfor
    call quickui#textbox#open(content, opts)
endfunc
nnoremap <leader>t :call DictSearch(expand('<cword>'))<cr>
vnoremap <leader>t :call DictSearch(<SID>get_visual_selection())<cr>

"easymotion {{{
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_smartcase = 1
nmap <Leader>s <Plug>(easymotion-overwin-f2)
"}}}
"
" mark {{{
" mark 插件的增强颜色
let g:mwDefaultHighlightingPalette = 'extended'
nmap <Plug>IgnoreMarkSearchNext <Plug>MarkSearchNext
nmap <Plug>IgnoreMarkSearchPrev <Plug>MarkSearchPrev
nmap * <Plug>MarkSearchOrCurNext
nmap # <Plug>MarkSearchOrCurPrev
nmap <leader>m <Plug>MarkSet
nmap <leader>mr <Plug>MarkRegex
nmap <Leader>mt <Plug>MarkToggle
nmap <Leader>mcc <Plug>MarkClear " avoid conflict with <leader>n :nohl
nmap <Leader>ma <Plug>MarkAllClear
"}}}

command Vcs so $MYVIMRC
command Vc tabnew $MYVIMRC
nmap <leader>n :nohl<CR>
nmap <leader>q :q!<cr>

autocmd FileType python let $PYTHONPATH ='/mnt/d/code/pytest/work'

command Cs CocCommand clangd.switchSourceHeader

" 状态栏 最近函数显示
function! NearestMethodOrFunction() abort "{{{
    return get(b:, 'vista_nearest_method_or_function', '')
endfunction "}}}
"set statusline+=%{NearestMethodOrFunction()}
let g:lightline = {
\    'colorscheme': 'sonokai',
\    'active': {
\        'left': [
\            [ 'mode', 'paste' ],
\            [ 'readonly', 'filename', 'modified', 'method' ,'vista_near'],
\            ]
\        },
\    'component_function': {
\        'method': 'NearestMethodOrFunction' ,
\        'test': 'Test_1'
\        },
\    'component_expend':{'vista_near':'NearestMethodOrFunction'},
\    'component_type': {
\        'method': 'error' ,
\        'test': 'verbose' ,
\        'vista_near': 'error'
\        },
\    }

" clang format {{{
let g:clang_format#detect_style_file=1
"let g:clang_format#code_style='Microsoft'
autocmd FileType c let g:clang_format#auto_format_on_insert_leave = 0
"let g:clang_format#command = "C:\Program Files\LLVM\bin\clang-format.exe"
            "AlignAfterOpenBracket" : "BAS_Align",
            "AllowShortIfStatementsOnASingleLine" : "SIS_Never",
            "AllowShortLoopsOnASingleLine" : "SLS_Never",
            "BreakBeforeBraces" : "AfterFunction",
            "UseTab" : "true",
let g:clang_format#style_options = {
            \"IndentWidth" : "4",
            \"IndentCaseLabels" : "true",
            \"ColumnLimit" : "0",
            \"PointerAlignment": "Left",
            \}
"map <C-k> :py3f "C:\Program Files\LLVM\share\clang\clang-format.py --version"<cr>
"map <C-k> :py3f 'C:\Program Files\LLVM\share\clang\clang-format.py'<cr>
"imap <C-k> <c-o>:py3f ~/PATH/TO/clang-format.py<cr>

"autocmd FileType c,cpp,objc nnoremap <buffer><Leader>f :<C-u>ClangFormat<CR>
"autocmd FileType c,cpp,objc vnoremap <buffer><Leader>f :ClangFormat<CR>
" if you install vim-operator-user
"autocmd FileType c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)
" Toggle auto formatting:
"nmap <Leader>af :ClangFormatAutoToggle<CR>
command Afl let g:clang_format#auto_format_on_insert_leave=0
command Afle echo g:clang_format#auto_format_on_insert_leave
command Af ClangFormatAutoToggle
" }}}

" Leaderf
" {{{
let g:Lf_WindowHeight =0.20
let g:Lf_PreviewInPopup = 1
"let g:Lf_WindowPosition = 'popup'
"let g:Lf_WindowPosition = 'bottom'
nmap <leader>l :Leaderf
nmap <leader>lf :Leaderf! file<CR>
nmap <leader>lb :Leaderf! buffer<CR>
nmap <leader>lj :Leaderf! jumps<CR>
nmap <leader>lr :Leaderf --regexMode rg --ignore-file D:\codeex\leaderf_ignore<CR>
nmap <leader>lfr :Leaderf  rg --ignore-file D:\codeex\leaderf_ignore<CR>
xnoremap <leader>gf :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR><CR>
noremap <leader>rr :<C-U>Leaderf! rg --recall<CR>
" 搜h cpp c文件 光标下字
noremap  <Leader>lw :let @/=expand('<cword>')<cr>:<C-U><C-R>=printf("Leaderf! rg --stayOpen -e %s -g *.{h,c,cpp}",expand("<cword>")) <CR><cr>
"}}}

function OpenLargeFile() "{{{
    if &filetype == 'help'
        return
    endif
	set nowrap
	set eventignore+=FileType
	setlocal bufhidden=unload
    set noma
	set nowrap
	syntax off
	autocmd VimEnter *  echo "file >" . (g:LargeFileLimit / 1024 ) . " KB, syntax nowrap off, guifont 8"
endfunction "}}}

