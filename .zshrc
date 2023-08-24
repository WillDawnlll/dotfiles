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
	TMPFILE="/tmp/antigen.zsh"
	if [ -x "$(which curl)" ]; then
		proxychains curl -L "$URL" -o "$TMPFILE"
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
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
source "$ANTIGEN"


export TERM="xterm-256color"
export COLORTERM=truecolor

ZSH_AUTOSUGGEST_USE_ASYNC=1

antigen bundle zpm-zsh/material-colors
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zdharma-continuum/fast-syntax-highlighting
antigen bundle woefe/vi-mode.zsh
antigen bundle zpm-zsh/ls
#antigen bundle softmoth/zsh-vim-mode

antigen apply

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{240}(%b)%r%f'
zstyle ':vcs_info:*' enable git
LS_COLORS='no=00;37:fi=00:di=00;33:ln=04;36:pi=40;33:so=01;35:bd=40;33;01:'
export LS_COLORS
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}  

export PROMPT="%(?.%F{cyan}√.%F{red}?%?)%f %B%F{240}%1~%f%b %# "

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -alF'
#alias la='ls -A'
#alias l='ls -CF'
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
