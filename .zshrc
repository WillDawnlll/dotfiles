if [[ -o login ]]; then
  if [[ -n $SSH_CONNECTION ]]; then
    if [[ -z $TMUX ]]; then
      echo "login ssh not tmux shell"
      #curl -d "[ $(uname -n) ] $(whoami) login  $(TZ=UTC-8 date "+%Y-%m-%d %H:%M:%S")" https://ntfy.sh/shdh_orpi1 -H p:3 &>/dev/null
    fi
  fi
fi


#export HTTP_PROXY="http://192.168.6.238:10809"
#export SOCKS_PROXY="socks://192.168.6.238:10808"
export HTTP_PROXY="http://localhost:10809"
export SOCKS_PROXY="socks://localhost:10808"

LANG="en_US.utf8"
#
# Antigen: https://github.com/zsh-users/antigen
ANTIGEN="$HOME/.local/bin/antigen.zsh"

# Install antigen.zsh if not exist
if [ ! -f "$ANTIGEN" ]; then
    echo "Installing antigen ..."
    [ ! -d "$HOME/.local" ] && mkdir -p "$HOME/.local" 2> /dev/null
    [ ! -d "$HOME/.local/bin" ] && mkdir -p "$HOME/.local/bin" 2> /dev/null
    # [ ! -f "$HOME/.z" ] && touch "$HOME/.z"
    URL="http://git.io/antigen"
    TMPFILE="$HOME/tmp/antigen.zsh"
    if [ -x "$(which curl)" ]; then
        proxychains4 curl -L "$URL" -o "$TMPFILE"
    elif [ -x "$(which wget)" ]; then
        wget "$URL" -O "$TMPFILE" 
    else
        echo "ERROR: please install curl or wget before installation !!"
        exit
    fi
    if [ ! $? -eq 0 ]; then
        echo ""
        echo "ERROR: downloading antigen.zsh ($URL) failed !!"
        exit
    fi;
    echo "move $TMPFILE to $ANTIGEN"
    mv "$TMPFILE" "$ANTIGEN"
fi

export PS1="%n@%m:%~%# "
export PATH="$HOME/bin:$HOME/.local/bin:$PATH:/usr/games"
source "$ANTIGEN"


export TERM="xterm-256color"
export COLORTERM=truecolor

ZSH_AUTOSUGGEST_USE_ASYNC=1

#antigen bundle zpm-zsh/dircolors-neutral
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zdharma-continuum/fast-syntax-highlighting
# fast-theme q-jmnemonic
antigen bundle woefe/vi-mode.zsh
#antigen bundle zpm-zsh/ls
#antigen bundle softmoth/zsh-vim-mode

antigen apply

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{240}(%b)%r%f'
zstyle ':vcs_info:*' enable git

#LS_COLORS='no=00;37:fi=00:di=00;33:ln=04;36:pi=40;33:so=01;35:bd=40;33;01:'
LS_COLORS='no=00:fi=00:di=36:ln=35:pi=37;44:so=37;44:do=37;44:bd=37;44:cd=37;44:or=05;37;45:mi=05;37;45:tw=30;46:ow=30;46:ex=01;31:*.cmd=01;31:*.exe=01;31:*.com=01;31:*.bat=01;31:*.reg=01;31:*.app=01;31:*.txt=33:*.org=33:*.md=33:*.mkd=33:*.C=32:*.c=32:*.cc=32:*.csh=32:*.css=32:*.cxx=32:*.el=32:*.h=32:*.hs=32:*.htm=32:*.html=32:*.java=32:*.js=32:*.man=32:*.objc=32:*.php=32:*.pl=32:*.pm=32:*.pod=32:*.py=32:*.rb=32:*.rdf=32:*.sh=32:*.shtml=32:*.tex=32:*.vim=32:*.xml=32:*.zsh=32:*.bmp=01;35:*.cgm=01;35:*.dl=01;35:*.dvi=01;35:*.emf=01;35:*.eps=01;35:*.gif=01;35:*.jpeg=01;35:*.jpg=01;35:*.JPG=01;35:*.mng=01;35:*.pbm=01;35:*.pcx=01;35:*.pdf=01;35:*.pgm=01;35:*.png=01;35:*.ppm=01;35:*.pps=01;35:*.ppsx=01;35:*.ps=01;35:*.svg=01;35:*.svgz=01;35:*.tga=01;35:*.tif=01;35:*.tiff=01;35:*.xbm=01;35:*.xcf=01;35:*.xpm=01;35:*.xwd=01;35:*.xwd=01;35:*.yuv=01;35:*.aac=01;35:*.au=01;35:*.flac=01;35:*.mid=01;35:*.midi=01;35:*.mka=01;35:*.mp3=01;35:*.mpa=01;35:*.mpeg=01;35:*.mpg=01;35:*.ogg=01;35:*.ra=01;35:*.wav=01;35:*.anx=01;35:*.asf=01;35:*.avi=01;35:*.axv=01;35:*.flc=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.m2v=01;35:*.m4v=01;35:*.mkv=01;35:*.mov=01;35:*.mp4=01;35:*.mp4v=01;35:*.mpeg=01;35:*.mpg=01;35:*.nuv=01;35:*.ogm=01;35:*.ogv=01;35:*.ogx=01;35:*.qt=01;35:*.rm=01;35:*.rmvb=01;35:*.swf=01;35:*.vob=01;35:*.wmv=01;35:*.doc=33:*.docx=33:*.rtf=33:*.dot=33:*.dotx=33:*.xls=33:*.xlsx=33:*.ppt=33:*.pptx=33:*.fla=33:*.psd=33:*.7z=1;35:*.apk=1;35:*.arj=1;35:*.bin=1;35:*.bz=1;35:*.bz2=1;35:*.cab=1;35:*.deb=1;35:*.dmg=1;35:*.gem=1;35:*.gz=1;35:*.iso=1;35:*.jar=1;35:*.msi=1;35:*.rar=1;35:*.rpm=1;35:*.tar=1;35:*.tbz=1;35:*.tbz2=1;35:*.tgz=1;35:*.tx=1;35:*.war=1;35:*.xpi=1;35:*.xz=1;35:*.z=1;35:*.Z=1;35:*.zip=1;35:*.ANSI-black=30:*.ANSI-black-bright=01;30:*.ANSI-red=31:*.ANSI-red-bright=01;31:*.ANSI-green=32:*.ANSI-green-bright=01;32:*.ANSI-yellow=33:*.ANSI-yellow-bright=01;33:*.ANSI-blue=34:*.ANSI-blue-bright=01;34:*.ANSI-magenta=35:*.ANSI-magenta-bright=01;35:*.ANSI-cyan=36:*.ANSI-cyan-bright=01;36:*.ANSI-white=37:*.ANSI-white-bright=01;37:*#=32:*~=32:*.log=32:*,v=01;30:*.BAK=01;30:*.DIST=01;30:*.OFF=01;30:*.OLD=01;30:*.ORIG=01;30:*.bak=01;30:*.dist=01;30:*.off=01;30:*.old=01;30:*.org_archive=01;30:*.orig=01;30:*.swo=01;30:*.swp=01;30:';
export LS_COLORS
autoload -U compinit  && compinit
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}  
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

if [[ $(uname -o) == "Android" ]] ;then
    MYIP=" "$(ifconfig 2>/dev/null| grep 'inet '| grep -v '127.0.0.1' | tail -1 | cut -d: -f2 | awk '{print $2}')
else
    MYIP=""
fi
#PS1="\[\033[01;31m\]\u@"$MYIP" \w $\[\033[00m\] ";

export PROMPT="%(?.%F{cyan}√.%F{red}?%?)%f %F{240}%1~%f%b"$MYIP" %# "

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    #test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ls='ls --color=auto'
alias ll='ls -alhF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias d='dirs -v'
alias 0='cd -0'
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'
alias wp='wslpath -w $(pwd)| clip.exe'
alias py3='python3'
alias pf='printf'
alias px='proxychains4'
alias sudo='sudo '
alias es='es -highlight '
alias pw='upower -i `upower -e | grep 'BAT'` '
#need apt install manpages-zh
manzh() {
    echo "in func manzh"
    if [ "$1" != "" ]; then
        bash -c 'LANG="zh_CN.UTF-8" '"&& man $1"
    fi
}
nreg() {
    proxychains -q python3 neoreg.py -k 'oprangepi0.0' -u https://op.wqfsva.ml/t.jsp -t 127.0.0.1:22
}
nf() {
    if [[ -n $1 ]]; then
        echo send...
        curl -d "$1" -s "https://ntfy.sh/shdh112" -H p:$2
    else
        echo fetch...
        curl -s "https://ntfy.sh/shdh112/json?poll=1" |tail -n 1
        #curl -s "https://ntfy.sh/shdh112/json?poll=1" |tail -n 1 | rg 'message":"(.*?)"' -or '$1'
    fi
}
#error 
enc() {
    echo $1 | openssl aes-256-cbc -a -pbkdf2 -salt -pass pass:$([[ -z $2 ]] && (echo p) || (echo $2)) 2>/dev/null
}
dec() {
    local input=""
    if [[ -p /dev/stdin ]]; then
        input="$(cat -)"
    fi
    if [[ -z "${input}" ]]; then
        echo stdin null
    else
        echo ${input} | openssl aes-256-cbc -d -a -pbkdf2 -pass pass:$([[ -z $1 ]] && (echo p) || (echo $1)) 
    fi
}
getstdin() {
    local input=""

    if [[ -p /dev/stdin ]]; then
        input="$(cat -)"
    else
        input="${@}"
    fi

    if [[ -z "${input}" ]]; then
        return
    else
        return ${input}
    fi

    #len:
    #echo "${#input}"
}
t1(){
    #local input="$(cat -)"
    #echo ${input}
    local i
    i= getstdin
    echo ${i}
}

setopt vi autocd autopushd pushdignoredups pushdminus

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.


#bindkey '^n' expand-or-complete
#bindkey '^p' reverse-menu-complete
bindkey '^r' history-incremental-search-backward

#for qt5 apps like : vlc
export QT_DEVICE_PIXEL_RATIO=1

. ~/z/z.sh || (echo "no ~/z/z.sh , clone https://github.com/rupa/z ";exit 1);

#term="$(cat /proc/$PPID/comm)"
#if [[ $term = "st" ]]; then
#    transset 0.8 --id "$WINDOWID" >/dev/null
#fi
