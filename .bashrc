#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
alias more='less'

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt
# force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
      # We have color support; assume it's compliant with Ecma-48
      # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
      # a case would tend to support setf rather than setaf.)
      color_prompt=yes
    else
      color_prompt=
    fi
fi

# Normal Colors
black='\[$(tput sgr0)\]\e[0;30m'        # black
red='\[$(tput sgr0)\]\e[0;31m'          # red
green='\[$(tput sgr0)\]\e[0;32m'        # green
yellow='\[$(tput sgr0)\]\e[0;33m'       # yellow
blue='\[$(tput sgr0)\]\e[0;34m'         # blue
purple='\[$(tput sgr0)\]\e[0;35m'       # purple
cyan='\[$(tput sgr0)\]\e[0;36m'         # cyan
white='\[$(tput sgr0)\]\e[0;37m'        # white

# Bold
BLACK='\[$(tput bold)\]\e[1;30m'        # Black
RED='\[$(tput bold)\]\e[1;31m'          # Red
GREEN='\[$(tput bold)\]\e[1;32m'        # Green
YELLOW='\[$(tput bold)\]\e[1;33m'       # Yellow
BLUE='\[$(tput bold)\]\e[1;34m'         # Blue
PURPLE='\[$(tput bold)\]\e[1;35m'       # Purple
CYAN='\[$(tput bold)\]\e[1;36m'         # Cyan
WHITE='\[$(tput bold)\]\e[1;37m'        # White

END="\e[m"              # Color Reset


echo -e "Hello BASH ${BASH_VERSION%.*}"
date

function _exit()              # Function to run upon exit of shell.
{
    echo -e "Bye BASH"bash
    date
}
trap _exit EXIT

SCHEME=default
case "$SCHEME" in
  A)
    primary=${YELLOW}
    secondary=${cyan}
    tertiary=${PURPLE}
    quad=${YELLOW}
    ;;
  *)
    primary=${RED}
    secondary=${green}
    tertiary=${BLUE}
    quad=${YELLOW}
    ;;
esac

# set a fancy prompt (non-color, unless we know we "want" color)
if [ "$color_prompt" = yes ]; then
  PS1="${debian_chroot:+($debian_chroot)}"
  PS1=${PS1}"${primary}\n\u${END} @ "
  PS1=${PS1}"${secondary}\h${END} in "
  PS1=${PS1}"${tertiary}\w${END} [ \t ]\n"
  PS1=${PS1}"${quad}\\$ ${END}"

  # make man pages more readable
  export LESS_TERMCAP_mb=$'\E[01;31m'
  export LESS_TERMCAP_md=$'\E[01;31m'
  export LESS_TERMCAP_me=$'\E[0m'
  export LESS_TERMCAP_se=$'\E[0m'
  export LESS_TERMCAP_so=$'\E[01;44;33m'
  export LESS_TERMCAP_ue=$'\E[0m'
  export LESS_TERMCAP_us=$'\E[01;32m'
else
  PS1="${debian_chroot:+($debian_chroot)}\u@\h:\w\$ "
fi
unset color_prompt force_color_prompt

export PROMPT_COMMAND="history -a"
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac



# colourize ls
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias mkdir='mkdir -p'

# Some typos
alias xs='cd'
alias vf='cd'

fw() { grep -Ern --color=auto "$1" . ;}
ff() { find . -type f | grep -E --color=auto "$1" ;}
fd() { find . -type d | grep -E --color=auto "$1" ;}

