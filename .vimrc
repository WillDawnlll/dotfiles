if 0
    source ~/_vim9rc
    finish
endif

let g:mapleader ="\<space>"

" 1/0 for bool v:true/v:false 
let s:is_win = has('win32')
let s:is_mac = has('osxdarwin')
let s:v = $HOME.(s:is_win ? '\vimfiles' : '/.vim')
let s:is_work = 0
let s:is_cursor_col = 1
let s:is_trans = 0
let s:is_dbglog = 0

function s:CONFIG_vim_base() "{{{
    " win外部程序依赖 (不包含 f2菜单 启动项): rg ctags gtags python3 pwsh(powershell7) html-beautify 
    "OS
    "{{{
    if s:is_win
        set shell=cmd.exe
        set shellcmdflag=/c
        set encoding=utf-8
        " Set PowerShell as shell
        "设置后 plug.vim 使用git的 转义字符错误 , 无法打开temp文件 , 命令出错
        "set shell=pwsh.exe
        "set shellcmdflag=-NoProfile\ -NoLogo\ -NonInteractive\ -Command
        "set shellpipe=|
        "set shellredir=>
    else
        " wsl vim
        set t_u7=
        "set t_Co=256
    endif
    " }}}

    "GUI
    "{{{
    if has('gui_running')
        " GUI font{{{
        "if has("gui_gtk2")
        "    :set guifont=Luxi\ Mono\ 12
        "elseif has("x11")
        "    " Also for GTK 1
        "    :set guifont=*-lucidatypewriter-medium-r-normal-*-*-180-*-*-m-*-*
        "elseif has("gui_win32")
        "    :set guifont=Luxi_Mono:h12:cANSI
        "endif

        "set guifont=Sarasa_Term_SC:h10  Term 不是等宽, 导致斜体英文超出显示范围 , W600 字重
        set guifont=sarasa_mono_SC_Nerd:h11:W600

        "set guifont=sarasa_mono_SC_Nerd_font:h11:W600
        "启用此行后菜单和提示气泡中文乱码
        "set gfw=youyuan:h10.5:cGB2312:qDRAFT
        "set guifont=Bitstream_Vera_Sans_Mono:h10:cANSI
        "set guifont=Ubuntu_Mono_derivative_Powerlin:h10:cANSI
        "set guifontwide=幼圆:h10.5:cGB2312

        "}}}

        source $VIMRUNTIME/delmenu.vim
        source $VIMRUNTIME/menu.vim

        "gui选项，去掉菜单栏等
        " :h guioptions 帮助
        set guioptions-=m
        set guioptions-=T
        set guioptions-=r
        set guioptions-=L
        "tab
        "set guioptions-=e


        " example from https://github.com/rstacruz/vim-from-scratch
        "set transparency =0  " not work in win32 gvim
        "set guifont=Iosevka\ Medium:h16 linespace=-1
        "set guioptions+=gme " gray menu items, menu bar, gui tabs
        set antialias
        "color ir_black+
    else
        " console colorscheme
        "Plug 'chriskempson/base16-vim'
        "color base16
    endif
    "}}}

    "normal
    "{{{
    " 显示状态行当前设置
    "set statusline

    " 设置状态行显示常用信息
    " {{{
    " %F 完整文件路径名
    " %m 当前缓冲被修改标记
    " %m 当前缓冲只读标记
    " %h 帮助缓冲标记
    " %w 预览缓冲标记
    " %Y 文件类型
    " %b ASCII值
    " %B 十六进制值
    " %l 行数
    " %v 列数
    " %p 当前行数占总行数的的百分比
    " %L 总行数
    " %{...} 评估表达式的值，并用值代替
    " %{"[fenc=".(&fenc==""?&enc:&fenc).((exists("+bomb") && &bomb)?"+":"")."]"} 显示文件编码
    " %{&ff} 显示文件类型
    " }}}
    "set statusline=set statusline=%F%m%r%h%w%=\ [ft=%Y]\ %{\"[fenc=\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\"+\":\"\").\"]\"}\ [ff=%{&ff}]\ [asc=%03.3b]\ [hex=%02.2B]\ [pos=%04l,%04v]\ [%p%%]\ [len=%L]

    " 设置 laststatus = 0 ，不显式状态行
    " 设置 laststatus = 1 ，仅当窗口多于一个时，显示状态行
    " 设置 laststatus = 2 ，总是显式状态行
    " 无此行  lightline 也不显示 
    set laststatus=2
    "set cmdheight=2
    set updatetime=300 

    " 不要将消息传递给|插入完成菜单|。 
    set shortmess+=c 
    set noswapfile
    set nobackup
    set nowritebackup
    set noundofile

    "'ts' 是制表符的显示方式； 'sts' 是按下 Tab 键时要插入多少个"空格"； 'sw' 是每个缩进级别使用多少个"空格"； 'et' 是使用空格还是制表符； 'sta' 允许您在行首按 Tab 键时插入 'sw'"空格"
    set et
    set ts=4
    set sw=4
    "filetype plugin indent on
    "set omnifunc=syntaxcomplete#Complete
    "set background=dark " recover plugin floaterm highlight Floaterm FloatermBorder color
    

    "折行
    set sidescroll=80
    "set linebreak
    "set breakat-=_
    "set showbreak=++++
    set cpoptions+=n
    nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
    nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
    "
    "开启后乱码
    "开启此行后菜单中文乱码 
    set enc=utf-8
    set fenc=utf8
    "set termencoding=cp936
    set fencs=utf-8,chinese,cp936,ucs-bom,
    "set fileencodings=utf-8,chinese
    "
    ""解决consle输出乱码
    "language messages zh_CN.cp936
    "language messages en_US.utf-8
    "
    "set langmenu=en_US
    "let $LANG = 'en_US'

    " 设置显示不可见字符
    " NonText" 高亮会用于 "eol"、"extends" 和 "precedes"
    " "SpecialKey" 用于 "nbsp","space"、"tab" 和 "trail"
    hi SpecialKey  gui=reverse guifg=#333333
    hi NonText gui=reverse guifg=#333333
    "set listchars=tab:> ,trail:-,extends:>,precedes:<,nbsp:+,space:·
    "set lcs+=space:·
    "set lcs=tab:>_,trail:-,extends:>,precedes:<,nbsp:+,space:·,eol:$
    set lcs=tab:>_,trail:-,extends:>,precedes:<,nbsp:+
    set list 
    "set invlist

    set relativenumber
    set nu
    augroup numbertoggle
        autocmd!
        autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
        autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
    augroup END

    " autoit 3000行时 重绘超时  , 语法高亮被禁用
    " 设定更大的超时时间
    set redrawtime=10000

    " 无声
    "set noeb
    " 闪屏代替声
    set vb

    " cursor {{{
    set cursorline
    let v:colornames['cursor_bg'] = s:is_trans ? '#333333' : v:colornames['black']
    hi Cursor  cterm=reverse gui=reverse
    hi CursorLine guibg=cursor_bg ctermbg=black
    "if s:is_win || !s:is_trans
    if s:is_cursor_col
        set cursorcolumn
        hi CursorColumn guibg=cursor_bg ctermbg=black
    endif
    "hi CursorColumn cterm=reverse gui=reverse
    "hi CursorLine cterm=reverse gui=reverse
    "}}}

    " default cterm=underline or undercurl ctermul guisp
    hi ErrorText guifg=yellow guibg=red
    "hi CocErrorHighlight links to ErrorText

    "tab
    "'guitabtooltip' 'gtt'	
    "Setting 'guitablabel'	
    "'guitablabel' 'gtl'	
    " hi Title 
    "hi VertSplit gui=none cterm=reverse
    "hi Folded ctermfg=grey ctermbg=darkgrey
    "hi FoldColumn ctermfg=4 ctermbg=7
    set guioptions-=e
    "set guitablabel=%N\ %t\ %M
    "set tabline=%N/\ %t\ %M
    " not active tab page label
    "hi TabLine ctermfg=white ctermbg=black
    "" where there are no labels
    "hi TabLineFill guifg=white guibg=dimgray 
    "    "ctermbg=dimgray
    ""active tab page label
    "hi TabLineSel guifg=white guibg=cyan1 
    "ctermbg=cyan1


    "hi diffAdded     gui=bold guifg=LightGreen
    "hi diffRemoved   gui=bold guifg=LightRed

    "hi diffFile      gui=NONE guifg=LightBlue
    "hi gitcommitDiff gui=NONE guifg=LightBlue
    "hi diffIndexLine gui=NONE guifg=LightBlue
    "hi diffLine      gui=NONE guifg=white

    hi visual  gui=reverse cterm=reverse
    "hi visual  guibg=#555555 ctermbg=555 term=reverse
    "old
    "hi Search  gui=bold guifg=black guibg=white 
    "new, for wsl
    hi Search  gui=bold guifg=white guibg=black

    hi CurSearch  gui=bold guifg=#000000 guibg=#FD971f 
    "old
    "hi IncSearch  gui=bold guifg=black guibg=white
    "new, for wsl
    hi IncSearch  gui=bold guifg=white guibg=black

    "term=reverse ctermbg=3
    set hlsearch 
    set incsearch
    " 上条后 so $MYVIMRC时 会直接高亮之前搜索结果 , 此条关闭
    nohl

    set whichwrap=b,s,<,>,[,],h,l 

    " * register (select text) system clipboard
    "set clipboard=unnamed
    " + register : x window clipboard
    set clipboard=unnamedplus

    " markdown context always auto fold , this disable
    set foldlevelstart=0
    "line 1 按j 跳过 line2 直接到line3
"set lines=4
"set columns=68
":e ~/ttttt
    set foldmethod=marker 

    "set nofoldenable
    set completeopt=menu,menuone
    set list
    set cino=(0
    set menc=cp936

    " when source vimrc , file will be modified (+)
    "set ff=unix

    set sb
    set spr

    set nofixendofline

    set wildchar=<Tab> wildmenu wildmode=full

    set  report       =0
    set  synmaxcol    =200

    set modeline
    "set cole=0

    " re map show full path
    nnoremap <c-g> 1

    let g:vimsyn_embed = 'P'
    " }}}
endfunction "}}}


let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

function s:CONFIG_vimplug() "{{{
    call plug#begin('~/.vim/plugged')
    "temp {{{
    Plug 'brglng/vim-im-select'
    "Plug 'markmap/coc-markmap'
    Plug 'github/copilot.vim'
    Plug 'jeetsukumaran/vim-filebeagle'
    "Plug 'preservim/nerdtree'
    "Plug 'justinmk/vim-dirvish'
    "
    "Plug 'yaegassy/coc-marksman',
    ""Plug 'mbbill/undotree'
    "Plug 'pboettch/vim-cmake-syntax'
    "Plug 'rhysd/vim-clang-format'
    ""Plug 'osyo-manga/vim-over'
    "Plug 's3rvac/vim-syntax-yara'
    ""Plug 'Shougo/vimproc.vim', {'do' : 'make'}
    ""Plug 'yuratomo/w3m.vim'
    ""Plug 'ashisha/image.vim'
    ""Plug 'fidian/hexmode' " open pdf create temp file error
    ""Plug 'vim-scripts/hexman.vim'
    ""Plug 'severin-lemaignan/vim-minimap'
    ""Plug 'wfxr/minimap.vim'", {'do': ':!cargo install --locked code-minimap'} " need comment plugin/minimap.vim 210 line , nunmap *#
    ""Plug 'puremourning/vimspector'
    ""Plug 'RRethy/vim-illuminate' " 高亮当前光标单词 ,因遮盖 mark 插件高亮, 停用
    ""Plug 'mhinz/vim-startify'
    ""Plug 'christianrondeau/vim-base64'
    ""Plug 'mattn/webapi-vim' 
    ""Plug 'mattn/vim-gist' "TODO:加一键更新vimrc
    ""Plug 'fidian/hexmode'
    ""Plug 'rootkiter/vim-hexedit' "hex 编辑时 右侧实时预览ASCII  windows无法打开temp文件 , 可能因为\符号转义 
    ""}}}

    "base {{{
    "无架构依赖 , win linux 通用 , linux 最小使用
    Plug 'yianwillis/vimcdoc'
    Plug 'Yggdroot/indentLine' " mess up markdown set cole=0
    "Plug 'preservim/vim-indent-guides'
    Plug 'junegunn/vim-easy-align'
    Plug 'inkarkat/vim-ingo-library' "mark 插件的依赖
    Plug 'inkarkat/vim-mark'
    Plug 'easymotion/vim-easymotion'
    "Plug 'frazrepo/vim-rainbow' " 会被语法高亮覆盖 , 用下面的代替
    Plug 'luochen1990/rainbow'
    Plug 'sainnhe/sonokai' " monokai pro  machine
    Plug 'skywind3000/vim-quickui'
    Plug 'xolox/vim-misc'
    Plug 'xolox/vim-session'
    "Plug 'voldikss/vim-floaterm'
    Plug 'skywind3000/asyncrun.vim'
    Plug 'voldikss/vim-translator'
    Plug 'plasticboy/vim-markdown'
    "}}}

    "code base {{{
    Plug 'itchyny/lightline.vim'
    Plug 'liuchengxu/vista.vim'
    Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " CocList extensions TODO explorer 安装后Ce无用
    "Plug 'weirongxu/coc-explorer', {'do': 'yarn install --frozen-lockfile'}
    ""Plug 'voldikss/coc-bookmark', {'do': 'yarn install --frozen-lockfile'}
    "Plug 'voldikss/coc-floaterm', {'do': 'yarn install --frozen-lockfile'}
    "Plug 'jackguo380/vim-lsp-cxx-highlight'
    "Plug 'm-pilia/vim-ccls'
    let g:polyglot_disabled = ['markdown']
    Plug 'sheerun/vim-polyglot' " 各语言语法高亮规则  缩进规则
    "Plug 'uiiaoo/java-syntax.vim'
    "Plug 'OrangeT/vim-csharp'
    "Plug 'mzlogin/vim-smali'
    "Plug 's3rvac/vim-syntax-yara'
    "}}}

    "code win {{{
    "Plug 'vim-scripts/visual_studio.vim'
    Plug 'spiiph/visual_studio' 
    "Plug 'pprovost/vim-ps1'
    "}}}

    " code linux {{{
    "Plug 'francoiscabrol/ranger.vim'
    "}}}

    "misc {{{
    "Plug 'godlygeek/tabular'
    "
    "Plug 'tpope/vim-fugitive'
    "Plug  'ryanoasis/vim-devicons' 
    "}}}
    call plug#end()
endfunction "}}}
call <sid>CONFIG_vimplug()

" plug config {{{
function s:CONFIG_plugs_base() "{{{
    " indentLine {{{
    let g:indentLine_char_list = ['|', '¦', '┆', '┊']
    "let g:indentLine_color_term = 239
    "let g:indentLine_bgcolor_term = 202
    "let g:indentLine_bgcolor_gui = '#FF5F00'
    "markdown set cole=0 not work
    let g:indentLine_setConceal = 0
    "let g:vim_json_conceal=0
    "let g:markdown_syntax_conceal=0
    "
    " }}}

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

    "plug mark{{{
    "             \m         : 将cursor下的单词加到下一个高亮group中
    "             [N]\m      : 将cursor下的单词加到指定的高亮group中
    "                          * 假如指定的高亮group已经有一个单词，则做或操作
    "                          * 假如cursor下的单词已经在某个高亮group中，则这个指令将删除这个
    "                           group
    "                          * 如果是在visual模式下，则对visual选择的部分做这个操作
    "                          * 当N比9大时，则用提示的方式要求用户选择一个group
    "             \n         : 将cursor下的单词所在的group删除
    "             [N]\n      : 将指定的group删除
    "             :[N]Mark   : 删除group N
    "             :[N]Mark[!] <pattern> : 在不指定group时，如果<pattern>不符合任何一个
    "                          group，将其加入下一个group；如果<pattern>符合某个group，删除这
    "                          个group。
    "                          如果指定了group，则用增加或移除的方式修改那个group，除非用”!”，此
    "                          时用强制赋值的方式修改那个group
    " 全局命令 	
    "             :Marks     : 显示所有Marks，”>”对应下一个默认组，”/”对应上一次搜索的组
    "             :Mark      : 禁用所有Marks，但并不删除它们
    "             :MarkClear : 删除所有Marks
    " 搜索命令 	
    "             \*         : 搜索同一个group中下一个实例
    "             \#         : 相反于\*
    "             \/         : 搜索所有group中下一个实例
    "             \?         : 相反与\/
    "             *          : 当cursor下的单词在group中时，重复上一次的\*，\#或\/，\?
    "                          当cursor下的单词不在group中时，使用默认的VIM行为
    "             #          : 相反于*
    " 小键盘数字 	
    "             [N][1~9]   : 小键盘的1到9对应9个group，搜索该group中的下N个实例
    "             [N][C-1~9] : 加Ctrl键，反方向搜索
    "}}}
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

    "easymotion {{{
    "map <Leader>e <Plug>(easymotion-prefix)
    "map <Leader>m <Plug>(mark-prefix)
    let g:EasyMotion_do_mapping = 0 " Disable default mappings
    " Turn on case-insensitive feature
    let g:EasyMotion_smartcase = 1
    " Jump to anywhere you want with minimal keystrokes, with just one key binding.
    " `s{char}{label}`
    "nmap s <Plug>(easymotion-overwin-f)
    " or
    " `s{char}{char}{label}`
    " Need one more keystroke, but on average, it may be more comfortable.
    nmap <Leader>s <Plug>(easymotion-overwin-f2)
    "}}}

    " rainbow
    let g:rainbow_active = 1
    let g:rainbow_conf = { 'separately': { 'cmake': 0, } }

    " color{{{
    "colorscheme molokai
    " plug sonokai config
    if has('termguicolors')
        set termguicolors
    endif
    " vim help : xterm-true-color
    " 只要终端支持，Vim 支持终端真彩 (使用 |highlight-guifg| 和 |highlight-guibg|)。
    " 为此，置位 'termguicolors' 选项。
    " https://gist.github.com/XVilka/8346728 有支持真彩的终端列表。
    " 有时置位 'termguicolors' 还不够，还需要显式设置 |t_8f| 和 |t_8b| 选项。这些选

    " The configuration options should be placed before `colorscheme sonokai`.
    let g:sonokai_style = 'atlantis'
    "let g:sonokai_style = 'andromeda'
    "let g:sonokai_style = 'maia'
    let g:sonokai_enable_italic = 0
    let g:sonokai_disable_italic_comment = 1
    colorscheme sonokai

    " st-alpha opacity , only work in tmux ??
    " !! in '!!system()' mean convert system() return value to bool (':h type()' 6)
    if s:is_trans
        if !!system('pgrep st-alpha') && !!system('pgrep picom')
            hi Normal guibg=NONE
            hi EndOfBuffer guibg=NONE
        else
            call Msgbox("linux not support transparency")
        endif
    else
        "hi Normal guibg=#333333
    endif
    "}}}

    nnoremap <Leader>h :Hexmode<CR>
    "inoremap <Leader>h <Esc>:Hexmode<CR>
    vnoremap <Leader>h :<CU>Hexmode<CR>

    "let g:floaterm_shell = "wsl"
    let g:floaterm_shell = "pwsh -nologo "
    "let g:floaterm_shell = "C:\\tools\\open_code\\msys64\\usr\\bin\\zsh.exe"
    "let g:floaterm_wintype = 'fl'
    let g:floaterm_width = 0.8
    let g:floaterm_height = 0.8
    let g:floaterm_autoclose =2
    command -nargs=* Fn FloatermNew <args> 
    let g:floaterm_keymap_new    = '<F6>'
    let g:floaterm_keymap_toggle = '<F7>'
    let g:floaterm_keymap_prev   = '<F8>'
    let g:floaterm_keymap_next   = '<F9>'
    let g:floaterm_keymap_kill   = '<f10>'
    " Configuration example

    " Set floaterm window's background to black
    hi Floaterm guibg=#666666
    " Set floating window border line color to cyan, and background to orange
    hi FloatermBorder guifg=cyan

    " vista {{{
    " Executive used when opening vista sidebar without specifying it.
    " 执行程序在未指定Vista侧边栏时使用。
    " See all the avaliable executives via `:echo g:vista#executives`.
    let g:vista_highlight_whole_line = 1
    let g:vista_stay_on_open = 0
    let g:vista_update_on_text_changed = 1
    let g:vista_echo_cursor_strategy = 'floating_win'
    "let g:vista#executives = ['coc','ctags','vim_lsp']
    let g:vista#executives = ['coc','ctags']
    let g:vista_default_executive = 'coc'
    " local_depend 本地目录依赖标志,换机需改
    "let g:vista_ctags_executable = 'C:\tools\open_code\ctags-2020-10-26_p5.9.20201025.0-2-g5d000b1a-x86\ctags.exe'
    let g:vista_executive_for = {'lua': 'coc', 'typescript': 'coc', 'go': 'coc', 'c': 'coc', 'javascript': 'coc', 'html': 'coc', 'rust': 'coc', 'cpp': 'coc', 'css': 'coc', 'python': 'coc','vim':'ctags','java':'coc'}
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
    " nmap  <leader>vo :Vista<cr>:wincmd p<cr>
    command Nt NERDTree
    command Ntc NERDTreeClose
    command Ntf NERDTreeFind
    " 状态栏 最近函数显示
    function! NearestMethodOrFunction() abort "{{{
        return get(b:, 'vista_nearest_method_or_function', '')
    endfunction "}}}
    "set statusline+=%{NearestMethodOrFunction()}
    let g:lightline = {
                \        'colorscheme': 'sonokai',
                \        'active': {
                \            'left': [
                \                [ 'mode', 'paste' ],
                \                [ 'readonly', 'filename', 'modified', 'method' ,'vista_near'],
                \            ] 
                \        },
                \        'component_function': {
                \            'method': 'NearestMethodOrFunction' ,
                \            'test': 'Test_1' 
                \        },
                \        'component_expend': {'vista_near':'NearestMethodOrFunction'},
                \        'component_type': {
                \            'method': 'error' ,
                \            'test': 'verbose' ,
                \            'vista_near': 'error' 
                \        }, 
                \     }
    set noshowmode
    function Test_1()
        return "Test_1"
    endfunction
    " By default vista.vim never run if you don't call it explicitly.
    " If auto show the nearest function in statuslie
    autocmd User CocStatusChange call vista#RunForNearestMethodOrFunction()
    "autocmd VimEnter * call vista#RunForNearestMethodOrFunction()
    "autocmd FileType cs,c,cpp,python call vista#RunForNearestMethodOrFunction()
    "autocmd CursorMoved * call lightline#update()

    "augroup LightLine
    "    autocmd!
    "    autocmd WinEnter,BufWinEnter,FileType,ColorScheme,SessionLoadPost * call lightline#update()
    "    autocmd ColorScheme,SessionLoadPost * call lightline#highlight()
    "    autocmd VimEnter * call Msgbox("vimEnter".col("."))
    "augroup END

    "let s:palette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette
    "let s:palette.normal.middle = [['#ffffff', '#000000', 0, 21]]
    "call g:lightline#colorscheme()

    "autocmd VimEnter * call SetupLightlineColors()
    "function SetupLightlineColors() abort
    "    " transparent background in statusbar
    "    let l:palette = lightline#palette()

    "    let l:palette.normal.middle = [ [ 'NONE', 'NONE', 'NONE', 'NONE' ] ]
    "    let l:palette.inactive.middle = l:palette.normal.middle
    "    let l:palette.tabline.middle = l:palette.normal.middle

    "    call lightline#colorscheme()
    "endfunction
    "}}}
endfunction "}}}

function s:CONFIG_plugs_cocconfig() "{{{
    "" common.vim
    "let g:coc_common = {
    "            \   "coc.preferences.currentFunctionSymbolAutoUpdate": v:true,
    "            \   "coc.source.ultisnips.priority": 10,
    "            \   "coc.source.buffer.priority": 5,
    "            \   "coc.source.word.priority": 1,
    "            \ }

    "" explorer.vim
    "let g:coc_explorer = {
    "            \   "explorer.icon.enableNerdfont": v:true,
    "            \   "explorer.keyMappings": {
    "            \     "<space>": "normal:j"
    "            \   },
    "            \ }

    "let g:coc_user_config = extend(g:coc_common, g:coc_explorer)

    " TODO shfmt
                "\"coc.preferences.hoverTarget": "float",
    " install: rustup component add rust-analyzer
    let g:coc_user_config = {
                \"coc.preferences.formatOnSaveFiletypes": ["rust"],
                \"diagnostic.checkCurrentLine": v:true,
                \"inlayHint.enable": v:false,
                \"python.jediEnabled": v:true,
                \"rust-analyzer.server.path": $HOME."/.cargo/bin/rust-analyzer",
                \"rust-analyzer.updates.checkOnStartup": v:false
                \}
    "let g:coc_user_config['coc.preferences.jumpCommand'] = ':SplitIfNotOpen4COC'
    
    " coc-rust-analyzer standalone signle rs file without cargo folder
    " https://rust-analyzer.github.io/manual.html#non-cargo-based-projects
    " touch rust-project.json in main.rs folder
    " https://github.com/rust-lang/rust-analyzer/issues/6388
    " {
    "     "sysroot_src": "/home/<YOUR-USER>/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library",
    "     "crates": [
    "         {
    "             "root_module": "main.rs",
    "             "edition": "2018",
    "             "deps": []
    "         }
    "     ]
    " }
    " coc config json rust-analyzer.linkedProjects with rus-project.json
    " let g:coc_user_config = {
    "             \"rust-analyzer.linkedProjects": [
    "             \{
    "             \    "sysroot_src": "/home/u1/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library",
    "             \    "crates": [
    "             \        {
    "             \            "root_module": "main.rs",
    "             \            "edition": "2021",
    "             \            "deps": [],
    "             \        },
    "             \    ]
    "             \}
    "             \]
    "             \}
endfunction "}}}

function s:CONFIG_plugs_ext() "{{{
    "session {{{
    let g:session_autosave=0
    "}}}
    "ycm {{{
    "let g:ycm_global_ycm_extra_conf = 'c:/users/test/.vim/ycm_extra_conf.py'
    ""let g:ycm_server_python_interpreter='C:\Users\test\AppData\Local\Programs\Python\Python37-32'
    ""set runtimepath+=C:\Program\\\ Files\\\ (x86)\Vim\vim-ycm-20200105\YouCompleteMe\
    "let g:ycm_add_preview_to_completeopt = 0
    "let g:ycm_show_diagnostics_ui = 0
    "let g:ycm_server_log_level = 'info'
    "let g:ycm_min_num_identifier_candidate_chars = 2
    "let g:ycm_collect_identifiers_from_comments_and_strings = 1
    "let g:ycm_complete_in_strings=1
    "let g:ycm_key_invoke_completion = '<c-z>'

    "let g:ycm_semantic_triggers =  {
    "           \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
    "           \ 'cs,lua,javascript': ['re!\w{2}'],
    "           \ }
    "let g:ycm_filetype_whitelist = { 
    "			\ "c":1,
    "			\ "cpp":1, 
    "			\ "objc":1,
    "			\ "sh":1,
    "			\ "zsh":1,
    "			\ "zimbu":1,
    "			\ }
    "}}}
    " translator {{{
    let g:translator_default_engines=['google',]
    "let g:translator_proxy_url = 'socks5://127.0.0.1:10808'
    "let g:translator_proxy_url = 'http://127.0.0.1:10809'
    "let g:translator_debug_mode=1 "log 中详细
    command  -nargs=* Tr Translate <args>
    command  -nargs=* Tre Translate --engines=google --target_lang=en <args>
    " 选中区域翻译
    vmap  <leader>g :TranslateW<cr>
    nmap  <leader>g :TranslateW<cr>
    "vmap  <Leader>ta :TranslateW --engines=google<cr>
    "nmap  <Leader>tg :TranslateW --engines=google<cr>
    vmap  <Leader>ge :TranslateW --engines=google --target_lang=en <cr>
    nmap  <Leader>ge :TranslateW --engines=google --target_lang=en <cr>
    "vmap  <Leader>tr :TranslateR --engines=google<cr>
    " 选中区域翻译到下一行
    nmap  <Leader>tn :call Tr_next_line()<cr>
    " 选中区域翻译结果到剪贴板
    " let @w= 'yyV:TranslateRP'
    function Tr_next_line()
        let @1= 'yyV:TranslateRP'
        "let url = matchstr(test, '==>.*')
        "if empty(url) 
        "   throw "no url recognized into ``".test."''"
        "endif
    endfunction
    "vmap <f4> :call Tr_toclip()<cr>
    "}}}
    " async run {{{
    "%:p     - 当前 buffer 的文件名全路径
    "%:t     - 当前 buffer 的文件名（没有前面的路径）
    "%:p:h   - 当前 buffer 的文件所在路径
    "%:e     - 当前 buffer 的扩展名
    "%:t:r   - 当前 buffer 的主文件名（没有前面路径和后面扩展名）
    "%       - 相对于当前路径的文件名
    "%:h:.   - 相对于当前路径的文件路径
    "<cwd>   - 当前路径
    "<cword> - 光标下的单词
    "<cfile> - 光标下的文件名
    "<root>  - 当前 buffer 的项目根目录
    command -nargs=* AR AsyncRun -mode=popup  <args>
    command -nargs=* ARt AsyncRun -mode=term <args>
    command -nargs=* ARf AsyncRun -mode=term -pos=floaterm <args>
    command -nargs=* ARe AsyncRun -mode=term -pos=external <args>
    "command -nargs=* AR AsyncRun -mode=popup -pos=tab <args>
    command -nargs=* ARc AR cmd   <args>
    "command -nargs=* ARp AR powershell -nologo -NoProfile  <args>
    command -nargs=* ARp AR powershell -nol -nop <args>
    command -nargs=* ARtp ARt powershell -nol -nop <args>
    command -nargs=* ARfp ARf powershell -nol -nop <args>
    command -nargs=* ARep ARe powershell -nol -nop <args>

    command -nargs=* EX AR explorer <args>
    command EXt AsyncRun explorer /select,%:p
    command EXd AsyncRun explorer  "C:\Users\test\desktop"
    "change directory (-cwd) before execution:  , set   environment variables 
    ":AsyncRun -mode=bang -cwd=<root> gcc -c "$(VIM_FILENAME)"
    function! s:run_floaterm(opts)
        "let cwd = getcwd()
        "let cmd = 'cd ' . shellescape(cwd) . ' && ' . a:opts.cmd
        "execute 'FloatermNew --position=topright --height=0.4 --width=0.5 --title=floaterm_runner --autoclose=1 ' . cmd
        " Back to the normal mode
        " stopinsert
        let curr_bufnr = floaterm#curr()
        if has_key(a:opts, 'silent') && a:opts.silent == 1
            FloatermHide!
        endif
        let cmd = 'cd ' . shellescape(getcwd())
        call floaterm#terminal#send(curr_bufnr, [cmd])
        call floaterm#terminal#send(curr_bufnr, [a:opts.cmd])
        " Back to the normal mode
        stopinsert
    endfunction

    let g:asyncrun_runner = get(g:, 'asyncrun_runner', {})
    let g:asyncrun_runner.floaterm = function('s:run_floaterm')
    let g:asynctasks_term_pos = 'floaterm'
    "}}}
    "ccls CocConfig {{{
    "{
    "    "languageserver": {
    "        "ccls": {
    "            "command": "ccls",
    "            "filetypes": ["c", "cpp", "objc", "objcpp"],
    "            "rootPatterns": [".ccls", "compile_commands.json", ".vim/", ".git/", ".hg/"],
    "            "initializationOptions": {
    "                "index":{"blacklist":["clsload.m"]},
    "                "cache": {
    "                    "directory": ".cache/ccls"
    "                },
    "                "client": {
    "                    "snippetSupport": true
    "                },
    "                "highlight": { "lsRanges" : true }
    "            }
    "        }
    "    }
    "}
    "}}}
    " Autoformat {{{
    ""noremap <F3> :Autoformat<CR>
    "let g:autoformat_verbosemode=1
    "" 指定html格式化工具，并设置缩进为两个空格 
    "" local_depend 本地目录依赖标志,换机需改
    "let g:formatdef_my_html = '"html-beautify -s 4"'
    "let g:formatters_html = ['my_html']
    "}}}
    " quickui {{{
    let g:quickui_color_scheme = 'papercol dark'
    let g:quickui_border_style = 2
    "}}}
    " coc explorer {{{
    let g:coc_explorer_global_presets = {
                \   'tab': {
                \     'position': 'tab',
                \     'quit-on-open': v:true,
                \   },
                \   'simplify': {
                \     'file-child-template': '[selection | clip | 1] [indent][icon | 1] [filename growRight 1 omitCenter 5]  [size]'
                \   },
                \   'buffer': {
                \     'sources': [{'name': 'buffer', 'expand': v:true}]
                \   },
                \ }
    "\     'file-child-template': '[selection | clip | 1] [indent][icon | 1] [filename | 60] [size]'
    "}}}
    nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>

    " coc complete suggestion
    "inoremap <silent><expr> <c-n> coc#refresh() 
    if &filetype == 'vim'
        "inoremap <silent><expr> <C-n> coc#pum#visible() ?  coc#pum#next(1) : coc#refresh()
        "inoremap <silent><expr> <C-p> coc#pum#visible() ?  coc#pum#prev(1) : coc#refresh()
    else
        inoremap <silent><expr> <C-n> coc#pum#visible() ?  coc#pum#next(1) : coc#refresh()
        inoremap <silent><expr> <C-p> coc#pum#visible() ?  coc#pum#prev(1) : coc#refresh()
    endif
endfunction "}}}

function s:CONFIG_plugs_temp() "{{{
    " minimap {{{
    let g:minimap_width = 10
    let g:minimap_highlight_range=1
    let g:minimap_highlight_search=1
    let g:minimap_git_colors=1
    let g:minimap_block_filetypes =['fugitive', 'nerdtree', 'tagbar', 'fzf' ]
    let g:minimap_block_buftypes  =['nofile', 'nowrite', 'quickfix', 'terminal', 'prompt']
    let g:minimap_close_filetypes =['startify', 'netrw', 'vim-plug']
    nmap <leader>mp :MinimapToggle<cr>
    nmap <leader>mu :MinimapUpdateHightLight<cr>
    "}}}


    " vim-over {{{
    command Ov OverCommandLine 
    let g:over_enable_cmd_window = 1
    let g:over_enable_auto_nohlsearch = 1
    let g:over#command_line#substitute#replace_pattern_visually = 1
    " }}}

    "w3m {{{
    let g:w3m#command = 'C:\tools\open_code\msys64\usr\bin\w3m.exe'
    "let HTTP_PROXY='http://127.0.0.1:10808'
    let g:w3m#homepage = "http://news.ycombinator.com/"
    let g:w3m#search_engine = 'http://search.yahoo.co.jp/search?search.x=1&fr=top_ga1_sa_124&tid=top_ga1_sa_124&ei=' . &encoding . '&aq=&oq=&p='
    "}}}
    "mark load {{{
    let MARK_RSRCAAAA=[', ''[0-9a-f]\{7,12}'',',', ''08\d\+''',' ''\u\l\{5,}''', '001f8b08''']
    let MARK_DNLS1 =['^#\d\+', '^#1[^0-9]', '#1\n', '^#1"', '"\d\+ ', ':[a-zA-Z0-9/_+=]\{20}"','#[!!!]',':\(\w\{1,3}[^a-zA-Z0-9]\)\{5}' ]
    let MARK_HRSTR =['\w\{4,}']
    let MARK_SSCLI =['field\c\|字段','type\c\|类型','class\c','.* | \d\+','^#\+ .*','TypeHandle\|TypeDef\|TypeDesc','sign\c\|符号','token\c\|令牌','\w\+TypeHandle\w\+','LoadType\w\+']
    let MARK_MONO_TRACE =['| \w.* (', '.*managed-to-native.*', '.*runtime-invoke.*', '\<LEAVE\>', '\<ENTER\>']
    "}}}
    "vimspector {{{
    "let g:vimspector_enable_mappings = 'HUMAN'
    let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
    " for normal mode - the word under the cursor
    nmap <Leader>di <Plug>VimspectorBalloonEval
    " for visual mode, the visually selected text
    xmap <Leader>di <Plug>VimspectorBalloonEval
    nmap <LocalLeader><F11> <Plug>VimspectorUpFrame
    nmap <LocalLeader><F12> <Plug>VimspectorDownFrame

    "sign define vimspectorBP            text=\ ● texthl=WarningMsg
    "sign define vimspectorBPCond        text=\ ◆ texthl=WarningMsg
    "sign define vimspectorBPDisabled    text=\ ● texthl=LineNr
    "sign define vimspectorPC            text=\ ▶ texthl=MatchParen linehl=CursorLine
    "sign define vimspectorPCBP          text=●▶  texthl=MatchParen linehl=CursorLine
    "sign define vimspectorCurrentThread text=▶   texthl=MatchParen linehl=CursorLine
    "sign define vimspectorCurrentFrame  text=▶   texthl=Special    linehl=CursorLine
    sign define vimspectorBP text=o             texthl=WarningMsg
    sign define vimspectorBPCond text=o?        texthl=WarningMsg
    sign define vimspectorBPDisabled text=o!    texthl=LineNr
    sign define vimspectorPC text=\ >           texthl=MatchParen
    sign define vimspectorPCBP text=o>          texthl=MatchParen
    sign define vimspectorCurrentThread text=>  texthl=MatchParen
    sign define vimspectorCurrentFrame text=>   texthl=Special

    func! s:CustomiseUI()
        call win_gotoid( g:vimspector_session_windows.code )
        " Clear the existing WinBar created by Vimspector
        nunmenu WinBar
        " Cretae our own WinBar
        nnoremenu WinBar.Kill :call vimspector#Stop( { 'interactive': v:true } )<CR>
        nnoremenu WinBar.Continue :call vimspector#Continue()<CR>
        nnoremenu WinBar.Pause :call vimspector#Pause()<CR>
        nnoremenu WinBar.Step\ Over  :call vimspector#StepOver()<CR>
        nnoremenu WinBar.Step\ In :call vimspector#StepInto()<CR>
        nnoremenu WinBar.Step\ Out :call vimspector#StepOut()<CR>
        nnoremenu WinBar.Restart :call vimspector#Restart()<CR>
        nnoremenu WinBar.Exit :call vimspector#Reset()<CR>
    endfunction

    augroup MyVimspectorUICustomistaion
        autocmd!
        autocmd User VimspectorUICreated call s:CustomiseUI()
    augroup END
    "}}}

    " vim-syntax-yara{{{
    autocmd BufNewFile,BufRead *.yar,*.yara setlocal filetype=yara
    "}}}

endfunction "}}}
"}}}

function s:CONFIG_au_filetype() "{{{
    " 补全path设置
    autocmd FileType markdown setlocal lcs-=trail foldmethod=marker
    " markdown syntax highlight hack
    " {{{
    "autocmd FileType markdown syn match mt0 '^# .*' containedin=ALL contained |hi mt0 guibg=gray90 guifg=gray30
    "autocmd FileType markdown syn match mt1 '^## .*' containedin=ALL contained |hi mt1 guibg=gray90 guifg=gray30
    "autocmd FileType markdown syn match mt2 '^### .*' containedin=ALL contained |hi mt2 guibg=gray90 guifg=gray30
    "autocmd FileType markdown syn match mt3 '^#### .*' containedin=ALL contained |hi mt3 guibg=gray90 guifg=gray30
    "autocmd FileType markdown syn match mt4 '^##### .*' containedin=ALL contained |hi mt4 guibg=gray90 guifg=gray30

    "autocmd FileType markdown syn match m11 '\*.\{-1,}\*' containedin=ALL contained |hi m11 guifg=cyan
    "autocmd FileType markdown syn match m12 '_.\{-1,}_' containedin=ALL contained  |hi m12 guifg=cyan
    "autocmd FileType markdown syn match m21 '\*\*.\{-1,}\*\*' containedin=ALL contained |hi m21 guifg=springgreen
    "autocmd FileType markdown syn match m22 '__.\{-1,}__' containedin=ALL contained |hi m22 guifg=springgreen
    "}}}
    autocmd FileType markdown nnoremap <leader>` ciw``<esc>P
    autocmd FileType markdown setlocal foldlevel=0
    "autocmd FileType markdown setlocal foldlevel=99
    "let g:vim_markdown_strikethrough = 1
    autocmd FileType markdown set synmaxcol =0 "超出后影响后续 所有行 高亮

    "" 控制 ** __ 符号颜色
    "autocmd FileType markdown highlight mkdBold guifg=#999999 ctermfg=208  
    " 控制粗体内容颜色
    autocmd FileType markdown highlight htmlBold guifg=cyan ctermfg=cyan
    autocmd FileType markdown highlight htmlItalic guifg=green ctermfg=green

    autocmd FileType html setlocal shiftwidth=2 tabstop=2

    if s:is_win
        autocmd FileType c setlocal noet path+=C:/Program\\\ Files\\\ (x86)/Windows\\\ Kits/10/Include/10.0.19041.0/
        "autocmd FileType python setlocal path+=C:/Users/test/AppData/Local/Programs/Python/Python39/Lib/
        autocmd FileType python setlocal path+=C:/Python27/Lib
        autocmd FileType python let $PYTHONPATH ='D:\code\pytest\work'
    elseif s:is_mac
        echo 123
        autocmd FileType python let $PYTHONPATH =$HOME.'/code/py'
    else
        autocmd FileType c setlocal et
        autocmd FileType python let $PYTHONPATH =$HOME.'/code/py/pytest/work'
    endif
    autocmd FileType c,cpp,python setlocal foldmethod=indent
    autocmd BufRead,BufNewFile *.h,*.c setlocal filetype=c list lcs=tab:\|_

    autocmd FileType diff set ft=gitcommit

    "remote_foreground(v:servername)

    autocmd FileType * call <SID>def_base_syntax() 
    function! s:def_base_syntax() "{{{
        syntax match commonOperator "\(+\|=\|-\|\^\|\*\|&\||\|>\|!\)"
        syntax match baseDelimiter ","
        hi link commonOperator Operator
        hi link baseDelimiter Special
    endfunction "}}}
endfunction "}}}

function s:CONFIG_macro() "{{{
    " 每两个字符中插入空格
    let @h= "i lll"
    " autoit 宏
    let @a= "0f\"ya\"IConsoleWrite(pa& @CRLF &A&@CRLF& @CRLF)j"
    " 变量重命名
    let @r= "yiw*#:%s/\"/"
endfunction "}}}

function s:CONFIG_map() "{{{
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
    " 搜索在* h和* cpp文件 光标下字
    "noremap  <Leader>lw :let @/=expand('<cword>')<cr>:<C-U><C-R>=printf("Leaderf! rg --stayOpen -e %s -g *.{h,c,cpp}",expand("<cword>")) <CR><cr>
    noremap  <Leader>lw :<C-U><C-R>=printf("Leaderf! rg --stayOpen -e %s -g *.{h,c,cpp}",expand("<cword>")) <CR><cr>
    "}}}

    " gtags for leaderf change to coc
    " {{{
    "let g:Lf_GtagsAutoGenerate = 1
    ""let g:Lf_Gtagslabel = 'native-pygments'
    "let g:Lf_Gtagslabel = 'native'
    "set tags+=tags;$HOME\.LfCache\gtags;
    "noremap <leader>lg :Leaderf --regexMode gtags --result  ctags-x<CR>
    "noremap <leader>lgu :Leaderf gtags --update <CR>
    "autocmd FileType c noremap <leader>lgu :Leaderf gtags --update --gtagslibpath "D:\codeex\codebase;C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\include;"<CR>
    "noremap <leader>lgu :Leaderf gtags --update<cr> 
    "noremap <leader>lgr :Leaderf gtags --remove<CR>
    "noremap <leader>lgf :Leaderf --ignore-file D:\codeex\leaderf_ignore  gtags --result  ctags-x<CR>
    "noremap <leader>gr :<C-U><C-R>=printf("Leaderf!   gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
    "noremap <leader>gd :<C-U><C-R>=printf("Leaderf!   gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
    "noremap <leader>go :<C-U><C-R>=printf("Leaderf!   gtags --recall %s", "")<CR><CR>
    "noremap <leader>gn :<C-U><C-R>=printf("Leaderf  gtags --next %s", "")<CR><CR>
    "noremap <leader>gp :<C-U><C-R>=printf("Leaderf  gtags --previous %s", "")<CR><CR>
    "}}}

    " base map
    " {{{
    noremap <c-z> <NOP>
    " 10次 @h 宏 , 并复制到剪贴板
    nmap <M-0> 0f"l10@hh<C-v>T"l"*yu
    " 搜索中文
    nmap <leader>z /[^\x00-\xff]\{2,\}<CR>
    "nmap <M-z> /[^\x00-\xff]\{2,\}<CR>
    " 删第二列地址
    nmap <M-d> 2gg0f0<C-v>Gf:d
    nmap <leader>n :nohl<CR>
    " 搜索 4字母以上连
    nmap <M-e> /\w\{4,}<CR>
    " 复制引号中内容到剪贴板
    nmap <M-'> 0f""*yi"
    " 复制/P(开始到行末到剪贴板, 并末尾加逗号
    "nmap <M-p> A,<esc>0/P("<CR><C-v>f,"*y
    nmap <M-s> 0/S("<CR><C-v>$h"*y
    " 当前光标开始到行末到剪贴板
    nmap <Leader>y4 <C-v>$"*y
    " 复制当前选中到剪贴板
    " 不可用
    "vmap <Leader>ys "*y
    " 剪贴板操作
    nmap <M-8> "*
    vmap <M-8> "*
    " 不保存退出
    nmap <leader>q :q!<cr>
    "分屏 调节
    " 累加替换
    " :'<,'>s/char\zs\d*\ze/\=line(".") - line("'<") + 1
    " 搜索或删除部分重复的两行(开头
    nmap <m-f> /^\(\w*\.\).*\n\1<cr>
    " :g/^\(\w*.\).*\n\1/d
    nmap <m-q> @q
    nmap <m-w> @w
    let @q= 'yiw/^*:2k'
    let @w= ':sp ./ass*2w.pyJ5_'
    nmap <m-1> :vertical res 3<cr>
    "  火狐搜选中文字 
    vmap <m-f> <m-8>y:ARf firefox -search "<C-r>*"<cr>

    " nN keep direction
    nnoremap <expr> n  'Nn'[v:searchforward]
    xnoremap <expr> n  'Nn'[v:searchforward]
    onoremap <expr> n  'Nn'[v:searchforward]

    nnoremap <expr> N  'nN'[v:searchforward]
    xnoremap <expr> N  'nN'[v:searchforward]
    onoremap <expr> N  'nN'[v:searchforward]

    " edit macro , "* edit register *
    nnoremap <leader>e  :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>

    " keep > < select
    xnoremap <  <gv
    xnoremap >  >gv

    nnoremap <m-i> :setl invlist<cr>

    " fix this virmc too long syntax error
    nnoremap <c-s> :syntax sync maxlines=3 minlines=3<cr>
    "}}}

    " cscope map
    " modify from https://cscope.sourceforge.net/cscope_maps.vim
    " {{{

    " linux kernel source cscope db generate
    " modify from https://cscope.sourceforge.net/large_projects.html
    "
    " LNX=/home/u1/code/linux/510/linux
    " cd / 	
    " find  $LNX                                                                \
    "     -path "$LNX/arch/*" ! -path "$LNX/arch/i386*" -prune -o               \
    "     -path "$LNX/include/asm-*" ! -path "$LNX/include/asm-i386*" -prune -o \
    "     -path "$LNX/tmp*" -prune -o                                           \
    "     -path "$LNX/Documentation*" -prune -o                                 \
    "     -path "$LNX/scripts*" -prune -o                                       \
    "     -path "$LNX/drivers*" -prune -o                                       \
    "     -name "*.[chxsS]" -print >/home/u1/code/linux/510/cs/cscope.files
    function Lcs()
        let lnx="/home/u1/code/linux/510"
        let lnxsrc=lnx.."/linux"
        let lnxdb=lnx.."/cs/cscope.files"
        let csfind = '!LNX='..lnx..';cd /; find $LNX
                    \ -path "$LNX/arch/*" ! -path "$LNX/arch/i386*" -prune -o
                    \ -path "$LNX/include/asm-*" ! -path "$LNX/include/asm-i386*" -prune -o
                    \ -path "$LNX/tmp*" -prune -o
                    \ -path "$LNX/Documentation*" -prune -o
                    \ -path "$LNX/scripts*" -prune -o
                    \ -path "$LNX/drivers*" -prune -o
                    \ -name "*.[chxsS]" -print >'..lnxdb
        let cscmd = '!cd '..lnx..'/cs;cscope -q -k -b'
        echo csfind
        echo cscmd
        exe csfind
        exe cscmd
        exe 'cs add '..lnx..'/cs'
    endfunction

    " This tests to see if vim was configured with the '--enable-cscope' option
    " when it was compiled.  If it wasn't, time to recompile vim... 
    if has("cscope")
        " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
        set cscopetag
        " check cscope for definition of a symbol before checking ctags: set to 1
        " if you want the reverse search order.
        set csto=0
        " add any cscope database in current directory
        if filereadable("cscope.out")
            cs add cscope.out  
        " else add the database pointed to by environment variable 
        elseif $CSCOPE_DB != ""
            cs add $CSCOPE_DB
        endif

        " show msg when any other cscope db added
        set cscopeverbose  
        "   's'   symbol: find all references to the token under cursor
        "   'g'   global: find global definition(s) of the token under cursor
        "   'c'   calls:  find all calls to the function name under cursor
        "   't'   text:   find all instances of the text under cursor
        "   'e'   egrep:  egrep search for the word under cursor
        "   'f'   file:   open the filename under cursor
        "   'i'   includes: find files that include the filename under cursor
        "   'd'   called: find functions that function under cursor calls
        "nmap <leader>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
        "nmap <leader>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
        "nmap <leader>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
        "nmap <leader>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
        "nmap <leader>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
        "nmap <leader>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
        "nmap <leader>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
        "nmap <leader>d :cs find d <C-R>=expand("<cword>")<CR><CR>	

        "nmap <leader>ss :vert scs find s <C-R>=expand("<cword>")<CR><CR>
        "nmap <leader>sg :vert scs find g <C-R>=expand("<cword>")<CR><CR>
        "nmap <leader>sc :vert scs find c <C-R>=expand("<cword>")<CR><CR>
        "nmap <leader>st :vert scs find t <C-R>=expand("<cword>")<CR><CR>
        "nmap <leader>se :vert scs find e <C-R>=expand("<cword>")<CR><CR>
        "nmap <leader>sf :vert scs find f <C-R>=expand("<cfile>")<CR><CR>	
        "nmap <leader>si :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
        "nmap <leader>sd :vert scs find d <C-R>=expand("<cword>")<CR><CR>


        """"""""""""" key map timeouts
        "
        " By default Vim will only wait 1 second for each keystroke in a mapping.
        " You may find that too short with the above typemaps.  If so, you should
        " either turn off mapping timeouts via 'notimeout'.
        "
        "set notimeout 
        "
        " Or, you can keep timeouts, by uncommenting the timeoutlen line below,
        " with your own personal favorite value (in milliseconds):
        "
        "set timeoutlen=4000
        "
        " Either way, since mapping timeout settings by default also set the
        " timeouts for multicharacter 'keys codes' (like <F1>), you should also
        " set ttimeout and ttimeoutlen: otherwise, you will experience strange
        " delays as vim waits for a keystroke after you hit ESC (it will be
        " waiting to see if the ESC is actually part of a key code like <F1>).
        "
        "set ttimeout 
        "
        " personally, I find a tenth of a second to work well for key code
        " timeouts. If you experience problems and have a slow terminal or network
        " connection, set it higher.  If you don't set ttimeoutlen, the value for
        " timeoutlent (default: 1000 = 1 second, which is sluggish) is used.
        "
        "set ttimeoutlen=100

    endif
    " }}}

    " EasyAlign
    " markdown table
    nnoremap  <Leader>tt :%EasyAlign *\|<cr>
endfunction "}}}

function s:CONFIG_cmd() "{{{
    command Vc tabnew $MYVIMRC
    command Vcs so $MYVIMRC

    command -nargs=1 Vs exe repeat("vs|",<args>)
    command -nargs=1 Sp exe repeat("sp|",<args>)

    command Sx syntax on
    command Sxo syntax off

    command! CopyPath let @+ = expand('%:p')
    command! CopyName let @+ = expand('%:h')

    " all window do n , jump search keyword pos
    "command As execute "normal *" | windo execute "normal! n" | call cursor(0,1)
    command As execute "normal yiw/<c-r>*<cr>" | windo execute "normal! n | call cursor(0,1)|wincmd h" 
    noremap <leader>a :As<enter>

    command T tabe ~/temp | execute "normal ggVG\"_d:w<cr>p"
    "nmap <leader>p :tabe ~/temp<cr>ggVG"_dp
    nmap <leader>p :T<cr>

    "gui font 
    " echo &guifont
    command! FontBigger  :let &guifont = substitute(&guifont, '\d\+', '\=submatch(0)+1', '')
    command! FontSmaller :let &guifont = substitute(&guifont, '\d\+', '\=submatch(0)-1', '')
    command! FontBlod :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)+100', '')
    command! FontLight :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)-100', '')

    noremap <C-=> :FontBigger<cr>:set guifont<cr>
    noremap <C-_> :FontSmaller<cr>:set guifont<cr>

endfunction "}}}

function s:CONFIG_lsp() "{{{
    nmap <leader>rn <Plug>(coc-rename)
    let g:ccls_log_file = expand('~/ccls.log')
    let g:lsp_cxx_hl_use_text_props = 1 "fix text props error msg
    nmap <silent> <C-s> <Plug>(coc-range-select)
    xmap <silent> <C-s> <Plug>(coc-range-select)
    "  Always show the signcolumn, otherwise it would shift the text each time 
    "  diagnostics appear/become resolved. 
    set  signcolumn=yes 
    let s:coc_extensions = [  'coc-python' ]
    inoremap <silent><expr> <m-space> coc#refresh()

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

    call coc#config("python.jediEnabled", v:false)
    command -nargs=* CL CocList <args>
    " coc-bookmark
    "
    command -nargs=* Cbt CocCommand bookmark.toggle <args>
    command -nargs=* Cbl CL bookmark
    " coc-explorer
    "
    command -nargs=* Ce CocCommand explorer --sources file+ --preset simplify  --width 30 --content-width 55 <args>
    "command -nargs=* Ce CocCommand explorer --sources buffer+,file+ --preset simplify  --width 64 --content-width 65 <args>
    nmap <leader>c :Ce<cr>
    "\--file-child-template   '[selection | clip | 1] [indent][icon | 1] [filename omitCenter 1] [size]'
    nmap <leader>cf :CocCommand explorer --focus --no-toggle<cr>

    " Use `[g` and `]g` to navigate diagnostics
    " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " GoTo code navigation.
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    nmap <leader>rn <Plug>(coc-rename)

    "xmap <leader>f  <Plug>(coc-format-selected)
    "nmap <leader>f  <Plug>(coc-format-selected)
    xmap <leader>f  <Plug>(coc-format)
    nmap <leader>f  <Plug>(coc-format)

    command Cs CocCommand clangd.switchSourceHeader

    nnoremap <silent><nowait><expr> <C-J> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-F>"
    nnoremap <silent><nowait><expr> <C-K> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-B>"
    inoremap <silent><nowait><expr> <C-J> coc#float#has_scroll() ? "\<C-R>=coc#float#scroll(1)\<CR>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-K> coc#float#has_scroll() ? "\<C-R>=coc#float#scroll(0)\<CR>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-J> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-F>"
    vnoremap <silent><nowait><expr> <C-K> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-B>"
endfunction "}}}

function s:CONFIG_win() "{{{
    " python {{{
    " win path
    " 官网 gvim82.exe 只装了32位 , 以下无法载入
    "set pythonhome=C:\Users\test\AppData\Local\Programs\Python\Python38
    "set pythonthreedll=C:\Users\test\AppData\Local\Programs\Python\Python38\python38.dll
    "set pythonthreehome="C:\Users\test\AppData\Local\Programs\Python\Python37-32"
    "set pythonthreedll=C:\Users\test\AppData\Local\Programs\Python\Python37-32\python37.dll
    set pythonthreehome="C:\Users\test\AppData\Local\Programs\Python\Python310"
    set pythonthreedll=C:\Users\test\AppData\Local\Programs\Python\Python310\python310.dll
    set pythonhome="C:\Python27_64"
    set pythondll=C:\Windows\System32\python27.dll
    "set pythondll=C:\Windows\SysWOW64\python27.dll
    let g:python3_host_prog='C:\Users\test\AppData\Local\Programs\Python\Python37-32\python.exe'
    "}}}

    "windowns IDE jmp {{{
    let pycharm_path='"'.escape(expand('C:\Program Files\JetBrains\PyCharm Community Edition 2021.1.3\bin\pycharm64.exe'), '\').'"'
    "visual_studio.dte_execute("put_file", "D:\\code\\vs08_test\\vs08_test\\vs08_test\\vs08_test.cpp",2,2)
    autocmd FileType c,cpp,cs nmap <f1> :exe printf("python visual_studio.dte.put_file(%s,%d,%d)",  '"'.escape(expand("%:p"), '\').'"', line("."), col(".")) <cr>
    autocmd FileType python nmap <f1> :exe printf("AR %s --line %d --column %d %s",pycharm_path , line("."), col("."),  '"'.escape(expand("%:p"), '\').'"') <cr>
    "autocmd FileType vim nnoremap <silent> <f1> :call <SID>show_documentation()<CR>
    autocmd BufEnter * sy sync maxlines=3 minlines=3
    "nmap <f3> :exe printf("python visual_studio.dte.build_solution(%s)",'"'.$TEMP . '\vs_output.txt'.'"'  )<cr>
    "import win32api
    "e_msg = win32api.FormatMessage(-2147352567)
    "print e_msg.decode('CP1251')
    "}}}
endfunction "}}}

" coc-explorer content menu "{{{
"}}}
"call <sid>CONFIG_coc_exp_menus()

"quickui other
"{{{
" display vim messages in the textbox
function! DisplayMessages()
    let x = ''
    redir => x
    silent! messages
    redir END
    let x = substitute(x, '[\n\r]\+\%$', '', 'g')
    let content = filter(split(x, "\n"), 'v:key != ""')
    let opts = {"close":"button", "title":"Vim Messages"}
    call quickui#textbox#open(content, opts)
endfunc

function! DisplayList(list1)
    let content = []
    for dl in a:list1
        let content+=[string(dl)]
    endfor
    let opts = {"close":"button", "title":"DisplayList"}
    call quickui#textbox#open(content, opts)
endfunc

function! DisplayDict(dict)
    let dlist=items(a:dict)
    let content = []
    for dl in dlist
        let content+=[dl[0].'  :  '.string(dl[1])]
    endfor
    let opts = {"close":"button", "title":"DisplayDict"}
    call quickui#textbox#open(content, opts)
endfunc

function! DisplayText(text)
    let content = [a:text]
    "let content = filter(split(a:text, "\n"), 'v:key != ""')
    let opts = {"close":"button", "title":"DisplayText"}
    call quickui#textbox#open(content, opts)
endfunc

function! DictSearch(word)
    "let rg="C:\\hr_repositories\\virdb\\tools\\win64\\rg.exe"
    let rg="rg"
    let ecdict="~/ECDICT/ecdict.csv"
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
        "
        "let tr = MatchStrAll(i,'".\{-}"')
        "if len(tr) == 1 || len(tr) ==2
        "    let i = tr[-1]
        "    let i_ = substitute(i,'"',"","g")
        "    let s=split(i_,"\\\\n")
        "    let content +=s
        "else
        "    let i_ = substitute(i,"\\\\n"," ","g")
        "    let i_ = substitute(i_,","," ","g")
        "    let i_ = substitute(i_," 0","","g")
        "    let content += [i_]
        "endif
        let content +=[""]
    endfor
    call quickui#textbox#open(content, opts)
endfunc
nnoremap <leader>t :call DictSearch(expand('<cword>'))<cr>
vnoremap <leader>t :call DictSearch(<SID>get_visual_selection())<cr>

function! TermExit(code) "{{{
    echom "terminal exit code: ". a:code
endfunc "}}}
let opts = {'w':60, 'h':8, 'callback':'TermExit'}
let opts.title = 'Terminal Popup'
command Pyt call quickui#terminal#open('python', opts)

" 通用 content menu
"let content = [
"            \ ["&select file in explorer\t\:EXt", 'EXt ' ],
"            \ ['-'],
"            \ ["&test\t\_", 'echo 123'],
"            \ ]
"" set cursor to the last position
"let opts = {'index':g:quickui#context#cursor}
""nmap <f2> :call quickui#context#open(content, opts)<cr>
"}}}

"function s:CONFIG_hr() "{{{
"}}}
"
function s:CONFIG_txkn() "{{{
    let g:MARK_TICL = ['SpaceMapping_\w\+', 'sas_de\w\+', '\<is_egress_ip\>']
    "TODO
    "let g:MARK_datanew = ['SpaceMapping_\w\+', 'sas_de\w\+', '\<is_egress_ip\>']
    echo "[!!!] CONFIG_txkn loaded"

endfunction "}}}

"custom func
"{{{
" copy matchs {{{
"{{{
"https://vim.fandom.com/wiki/Copy_search_matches
" Copy matches of the last search to a register (default is the clipboard).
" Accepts a range (default is whole file).
" 'CopyMatches'   copy matches to clipboard (each match has \n added).
" 'CopyMatches x' copy matches to register x (clears register first).
" 'CopyMatches X' append matches to register x.
" We skip empty hits to ensure patterns using '\ze' don't loop forever.
" }}}
command! -range=% -register CopyMatches call s:CopyMatches(<line1>, <line2>, '<reg>')
function! s:CopyMatches(line1, line2, reg) "{{{
  let hits = []
  for line in range(a:line1, a:line2)
    let txt = getline(line)
    let idx = match(txt, @/)
    while idx >= 0
      let end = matchend(txt, @/, idx)
      if end > idx
	call add(hits, strpart(txt, idx, end-idx))
      else
	let end += 1
      endif
      if @/[0] == '^'
        break  " to avoid false hits
      endif
      let idx = match(txt, @/, end)
    endwhile
  endfor
  if len(hits) > 0
    let reg = empty(a:reg) ? '+' : a:reg
    execute 'let @'.reg.' = join(hits, "\n") . "\n"'
  else
    echo 'No hits'
  endif
endfunction "}}}
"{{{
" Use 0"+y0 to clear the clipboard, then
"    :g/pattern/call CopyMultiMatches()
" to copy all multiline hits (just the matching text).
" This is for when the match extends over multiple lines.
" Only the first match from each line is found.
" BUG: When searching for "^function.*\_s*let" the '.*' stops at the end
" of a line, but it greedily skips "\n" in the following (we copy too much).
"}}}
function! CopyMultiMatches() "{{{
  let text = join(getline(".", "$"), "\n") . "\n"
  let @+ .= matchstr(text, @/) . "\n"
endfunction "}}}
"}}}
" AL {{{
"function! AL()
 "}}}
 
function Notify(msg) "{{{
    if s:is_win
        echo "FUNC no notify-send"
        finish
    endif
    call system('notify-send -u critical "VIM Notify" "'.a:msg.'"')
endfunction "}}}

function Msgbox(msg) "{{{
    if !has("python3")
        echo "FUNC no python3"
        if !s:is_win
            Notify(msg)
        endif
        finish
    endif
    py3 import sys
    "py3 print(sys.argv)
    exec printf("py3 sys.argv=[r\"%s\"]",a:msg)
    py3 print(f"pymsg {sys.argv}")

    if s:is_win
        py3 << trim EOF
        #import ctypes,sys
        #ctypes.windll.user32.MessageBoxA(0,sys.argv[0].encode("ascii"),"vim_debug_msg",0)
        EOF
    else
        py3 << trim EOF
        #import tkinter as tk
        from tkinter import messagebox
        messagebox.showwarning("info",sys.argv[0])
        EOF
    endif
endfunction "}}}

"winpos 显示当前设置
function GetGvimRect() "{{{
	if !has("python3")
		echo "FUNC no python3"
		finish
	endif

	py3 << trim EOF
        import ctypes
        from ctypes import wintypes as w
        u32=ctypes.windll.user32
        hdl=u32.GetFocus()
        rect=w.RECT()
        if u32.GetWindowRect(hdl,ctypes.pointer(rect)):
            print(rect.left)
            print(rect.top)
            print(rect.right)
            print(rect.bottom)
	EOF
endfunction "}}}

"winpos 500 250
function SetRectMid() "{{{
    winpos 500 250 
    set lines=42 columns=200
    return

	if !has("python3")
		echo "FUNC no python3"
		finish
	endif

	py3 << trim EOF
		import ctypes
		u32=ctypes.windll.user32
		if not u32.MoveWindow(u32.GetFocus(),500,250,1420,800,1):
			print("SetRectMid failed")
	EOF
endfunction "}}}


function SetRectMini() "{{{
	if !has("python3")
		echo "FUNC no python3"
		finish
	endif

	py3 << trim EOF
		import ctypes
		u32=ctypes.windll.user32
		if not u32.MoveWindow(u32.GetFocus(),500,250,1420,800,1):
			print("SetRectMini failed")
	EOF
endfunction "}}}

function AcrossFullScreen() "{{{
	if !has("python3")
		echo "FUNC no python3"
		finish
	endif
	py3 << trim EOF
		import ctypes
		u32=ctypes.windll.user32
		if u32.MoveWindow(u32.GetFocus(),0,0,3840,1040,1):
			print("AcrossFull ok")
	EOF
endfunction "}}}

function AcrossMidScreen() "{{{
	if !has("python3")
		echo "FUNC no python3"
		finish
	endif
	py3 << trim EOF
		import ctypes
		u32=ctypes.windll.user32
		if u32.MoveWindow(u32.GetFocus(),500,250,2840,800,1):
			print("AcrossMid ok")
	EOF
endfunction "}}}

" ToggleCrossMax 
let g:max_bool=0
function ToggleCrossMax()"{{{
    if g:max_bool==0
        set nowrap
        " set columns not cross window 
        call AcrossMidScreen()
        let g:max_bool=1
    elseif g:max_bool==1
        winpos 0 0
        set lines=52 columns=241
        let g:max_bool=2
    elseif g:max_bool==2
        set nowrap
        " set columns not cross window 
        call AcrossFullScreen()
        let g:max_bool=3
    elseif g:max_bool==3
        set nowrap
        set lines=38 columns=90
        winpos 1180 250
        "let pos=getwinpos()
        "if pos[0]==500&&pos[1]==250
        "    let g:max_bool=0
        "endif
        let g:max_bool=4
    else
        "set nowrap
        "call SetRectMid()
        "set lines=42 columns=200
        set lines=38 columns=190
        "set lines=67 columns=438
        "winpos 500 250
        winpos 350 250
        "winpos 0 0 
        "let pos=getwinpos()
        "if pos[0]==500&&pos[1]==250
        "    let g:max_bool=0
        "endif
        let g:max_bool=0
	endif
endfunction"}}}
map <leader><F12> :call ToggleCrossMax()<cr>
"map <leader><F12> :call AcrossFullScreen()<cr>


" LargeFile {{{
let g:LargeFileLimit = 1 * 1024 * 100
let g:LARGEFILE = 0
augroup LargeFile 
	au!
    " TODO open vim help file (&filetype == 'help' , dont call OpenLargeFile
	"autocmd BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFileLimit || f == -2  | call OpenLargeFile() | endif
    "autocmd BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFileLimit || f == -2 | let g:LARGEFILE=1 | endif
    "autocmd VimEnter * if g:LARGEFILE | echo "file >" . (g:LargeFileLimit / 1024 ) . " KB, manual call OpenLargeFile()" |endif
    "
    autocmd BufReadPre * if v:servername =~? "lf_.*" | call OpenLargeFile() |endif
augroup END

function OpenLargeFile() "{{{
    if g:flgtx==1
        return
    endif
    "call Msgbox(&filetype)
    if &filetype == 'help'
        return
    endif
    set nowrap
    " no syntax highlighting etc
    set eventignore+=FileType
    " save memory when other file is viewed
    setlocal bufhidden=unload
    " is read-only (write with :w new_filename)
    "setlocal buftype=nowrite
    " no undo possible
    "setlocal undolevels=-1
    ":call libcallnr("D:\\code\\bypass\\WndOpa\\gvim_across_max.dll", "AcrossFullScreen", 0)
    set nowrap
    syntax off
    set guifont=sarasa_mono_SC_Nerd:h8:W600
    set lines=55
    set columns=269
    "call AcrossFullScreen()
    " display message
    autocmd VimEnter *  echo "file >" . (g:LargeFileLimit / 1024 ) . " KB, syntax nowrap off, guifont 8"
endfunction "}}}
"}}}


function! s:get_visual_selection()"{{{
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction"}}}

function MatchStrAll(str, pat)"{{{
    let l:res = []
    call substitute(a:str, a:pat, '\=add(l:res, submatch(0))', 'g')
    return l:res
endfunction"}}}

function ClearRegs()"{{{
    let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
    for r in regs
        call setreg(r, [])
    endfor
endfunction"}}}

function Cmd2clip(cmdstr)"{{{
    let x = ''
    redir => x
    silent exe a:cmdstr
    redir END
    let @+ = x
    echo @+
endfunction"}}}
command -nargs=1 C2c call Cmd2clip("<args>")

function SetProxy()"{{{
    let $all_proxy ="socks5://127.0.0.1:10808"
endfunction"}}}

function FormatPeriod()"{{{
    :%s/\./\.\r/g
    :%s/\(\w\|,\)\n\([^\n]\)/\1 \2/g
endfunction"}}}

function SetWinAlpha(n) "{{{
    if !has("python3")
        echo "FUNC no python3"
        finish
    endif
    py3 << trim EOF
        from ctypes import windll
        u32 = windll.user32
        GWL_EXSTYLE = -20
        WS_EX_LAYERED = 0x00080000
        LWA_ALPHA = 2
        hwnd = u32.FindWindowW("Vim",None)
        ste = u32.GetWindowLongA(hwnd, GWL_EXSTYLE)
        n = int(vim.eval("a:n"))
        #print(f"arg: {n} {type(n)}")
        if n == 0 :
            u32.SetWindowLongA(hwnd, GWL_EXSTYLE, ste & ~WS_EX_LAYERED)
        else:
            u32.SetWindowLongA(hwnd, GWL_EXSTYLE, ste | WS_EX_LAYERED)
            u32.SetLayeredWindowAttributes(hwnd, 0, n&0xff, LWA_ALPHA)
    EOF
endfunction "}}}

let g:wincaption=1
function ToggleCaption() "{{{
    " vimscript py2 version vimtweak : https://gist.github.com/skywind3000/8eb41acd9d5175715694c765f92fa667/ad238da01e3c48288ce3f2e82b5248a1598def53
    if !has("python3")
        echo "FUNC no python3"
        finish
    endif
    py3 << trim EOF
        from ctypes import *
        import ctypes.wintypes as wt
        HWND, LPARAM, BOOL = wt.HWND, wt.LPARAM, wt.BOOL
        u32=windll.user32
        k32=windll.kernel32

        WNDENUMPROC = WINFUNCTYPE( BOOL, HWND, LPARAM,)
        GWL_STYLE = -16
        GWL_EXSTYLE = -20
        WS_CAPTION = 0xc00000

        WS_THICKFRAME  = 0x00040000
        WS_MAXIMIZEBOX  = 0x00010000
        WS_MINIMIZEBOX = 0x00020000
        WS_SYSMENU = 0x00080000
        WS_BORDER = 0x00800000

        WS_EX_DLGMODALFRAME = 0x00000001
        WS_EX_CLIENTEDGE = 0x00000200
        WS_EX_STATICEDGE = 0x00020000
        WS_EX_WINDOWEDGE = 0x00000100
        hwnd = None

        def wtext(hwnd):
            buff = create_unicode_buffer(0x100)
            u32.GetWindowTextW(hwnd, buff, 0x100)
            if buff.value:
                #print(f'{cast(hwnd,c_void_p).value:08x} :  {buff.value}')
                print(f'{hwnd:08x} : "{buff.value}"')
                u32.GetClassNameW(hwnd, buff, 0x100)
                print(f'cls: {hwnd:08x} : "{buff.value}"')
            else:
                print(f'{hwnd:08x} : no wintext [{type(buff.value)} len: {len(buff.value)}]')
                u32.GetClassNameW(hwnd, buff, 0x100)
                print(f'cls: {hwnd:08x} : "{buff.value}"')

        def findw(h, lp):
            global hwnd
            wtext(h)
            if u32.GetParent(h):
                hwnd = None
                return True
            hwnd = h
            #print("%x,%d"%(h,lp))
            return False
        fwp = WNDENUMPROC(findw)
        id = k32.GetCurrentThreadId()
        #u32.EnumThreadWindows(id, fwp, 1234)
        print("enum done")
        hwnd = u32.FindWindowW("Vim",None)
        wtext(hwnd)

        st = u32.GetWindowLongA(hwnd, GWL_STYLE)
        ste = u32.GetWindowLongA(hwnd, GWL_EXSTYLE)

        if st & WS_CAPTION:
            u32.SetWindowLongA(hwnd, GWL_STYLE, st & ~(WS_CAPTION | WS_THICKFRAME ))
            #u32.SetWindowLongA(hwnd, GWL_STYLE, st & ~(WS_CAPTION | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX | WS_SYSMENU))
            #u32.SetWindowLongA(hwnd, GWL_EXSTYLE, ste & ~(WS_EX_DLGMODALFRAME | WS_EX_CLIENTEDGE | WS_EX_STATICEDGE))
            #u32.SetWindowLongA(hwnd, GWL_EXSTYLE, ste & ~(WS_EX_CLIENTEDGE|WS_EX_WINDOWEDGE))
            #u32.SetWindowLongA(hwnd, GWL_EXSTYLE, ste & ~WS_EX_CLIENTEDGE)
            u32.SetWindowLongA(hwnd, GWL_EXSTYLE, ste & ~WS_EX_WINDOWEDGE)
            #print("disable caption")
        else:
            u32.SetWindowLongA(hwnd, GWL_STYLE, st | WS_CAPTION| WS_THICKFRAME)
            #u32.SetWindowLongA(hwnd, GWL_STYLE, st |WS_BORDER)
            u32.SetWindowLongA(hwnd, GWL_EXSTYLE, ste |WS_EX_WINDOWEDGE)
            #u32.SetWindowLongA(hwnd, GWL_EXSTYLE, ste |(WS_EX_CLIENTEDGE|WS_EX_WINDOWEDGE))
            #print("enable caption")
        #print(f'{u32.UpdateWindow(hwnd):08x}')
    EOF
    call FixBottom()
    if g:wincaption==1
        let g:wincaption=0
    else
        let g:wincaption=1
    endif
endfunction "}}}
if s:is_win
    au VimEnter * call ToggleCaption()
    nmap <F11> :call ToggleCaption()<cr>
endif

function FixBottom() "{{{
    if !has("python3")
        echo "FUNC no python3"
        finish
    endif
    py3 << trim EOF
        from ctypes import *
        SWP_SHOWWINDOW = 0x40
        u32=windll.user32
        h = u32.FindWindowW("Vim",None)
        r = wintypes.RECT()
        u32.GetWindowRect(h, pointer(r))
        #print(u32.MoveWindow(h, r.left, r.left, r.right-r.left, r.bottom-r.top, 1))
        HWND_TOP = 0
        if r.left < 0: r.left=0
        if r.top < 0: r.top=0
        wincaption = int(vim.eval("g:wincaption"))
        print(f'wincaption {wincaption}')
        u32.SetWindowPos( hwnd, HWND_TOP, r.left, r.top, r.right-r.left, r.bottom-r.top+(19 if wincaption else -19), SWP_SHOWWINDOW)
    EOF
endfunction "}}}
if s:is_win
    nmap <F12> :call FixBottom()<cr>
endif

function W() "{{{
    if !has("python3")
        echo "FUNC no python3"
        finish
    endif
    py3 << trim EOF
        from ctypes import *
        u32=windll.user32
        h = u32.FindWindowW("Vim",None)
        r = wintypes.RECT()
        if not u32.GetWindowRect(h, pointer(r)):
            exit()
        print(f'l{r.left} t{r.top} r{r.right} b{r.bottom}')
        print(f'w{r.right-r.left} h{r.bottom-r.top}')
        buff = create_unicode_buffer(0x100)
        u32.GetWindowTextW(hwnd, buff, 0x100)
        if buff.value:
            print(f'{hwnd:08x} : "{buff.value}"')

    EOF
endfunction "}}}
if s:is_win
    nmap <F2> :call W()<cr>
endif

set cscopequickfix=s-,c-,d-,i-,t-,e-,a-
augroup MyQuickfixPreview
  au!
  au FileType qf noremap <silent><buffer> p :call quickui#tools#preview_quickfix()<cr>
augroup END

" pandoc markdown to html, firefox open it
function Pmd() "{{{
    "let tmpfile=tempname()
    sil exe "!pandoc -f markdown -o " .. expand("%") .. ".html" .. " % &"
    sil exe "!firefox " .. expand("%") .. ".html"
    redraw!
endfunction "}}}
"map <c-m> :call Pmd()<cr>

function! s:pgrep(procname) "{{{
    if !s:is_dbglog
        return !!system('pgrep "' . a:procname . '"')
    else
        let _ret = !system('pgrep "' . a:procname . '"')
        echo 'log: '.a:procname.' ret:'._ret.' type:'.type(_ret)
        echo 't: '.(_ret == v:true)
        echo 'f: '.(_ret == v:false)
        return _ret
    endif
endfunction "}}}

"TEMP
"" set bg color transparency when run in st-alpha with picom
"let s:is_st = <sid>pgrep("st-alpha")
"let s:is_picom = <sid>pgrep("picom")
""echo 'is_st '.s:is_st
""echo 'is_pi '.s:is_picom

"TODO store variable in so ?
function! ToggleLinuxTransparency() "{{{
    if s:is_trans
        let s:is_trans = 0
    else
        let s:is_trans = 1
    endif
    echo 's:is_trans '.s:is_trans
endfunction "}}}
if !s:is_win
    nmap <F2> :call ToggleLinuxTransparency()<cr>
    "TEMP
    function Test()
        echo s:is_trans
        echo v:colornames['cursor_bg']
    endfunction
    nmap <F3> :call Test()<cr>
endif

"vim-im-select

if s:is_mac
    "autocmd InsertEnter * AsyncRun im-select com.apple.inputmethod.SCIM.Shuangpin
    autocmd InsertLeave * AsyncRun im-select com.apple.keylayout.ABC
endif
if s:is_win
    autocmd InsertEnter * AsyncRun /mnt/d/tools/im-select.exe 2052
    autocmd InsertLeave * AsyncRun /mnt/d/tools/im-select.exe 1033
endif
" }}}




"if exists('g:loaded_lightline_powerful') || v:version < 800
"  finish
"endif
"let g:loaded_lightline_powerful = 1

call <sid>CONFIG_plugs_base() " not cover base set , call must before vim_base
call <sid>CONFIG_vim_base()
call <sid>CONFIG_plugs_cocconfig()
call <sid>CONFIG_plugs_ext()
call <sid>CONFIG_au_filetype()
call <sid>CONFIG_macro()
call <sid>CONFIG_map()
call <sid>CONFIG_cmd()
call <sid>CONFIG_lsp()

if s:is_win
    call <sid>CONFIG_plugs_temp()
    call <sid>CONFIG_win()
    source ~/vimrc/winwork.vimrc
    "call <sid>CONFIG_hr()
    source ~/vimrc/misc.vimrc
endif

if s:is_mac
    call <sid>CONFIG_txkn()
endif
"TODO try catch , source empty vimrc , no plug mode restart vim
"TEMP
"set csprg= "C:/tools/open_code/cscope/cscope.exe"
