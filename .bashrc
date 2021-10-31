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
    xterm-color|*-256color|screen) color_prompt=yes;;
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

# Colours come from https://gist.github.com/leesei/136b522eb9bb96ba45bd
# Normal Colors
 black='\[\033[0m\]\[\033[38;5;0m\]'  # black
   red='\[\033[0m\]\[\033[38;5;1m\]'  # red
 green='\[\033[0m\]\[\033[38;5;2m\]'  # green
yellow='\[\033[0m\]\[\033[38;5;3m\]'  # yellow
  blue='\[\033[0m\]\[\033[38;5;4m\]'  # blue
purple='\[\033[0m\]\[\033[38;5;5m\]'  # purple
  cyan='\[\033[0m\]\[\033[38;5;6m\]'  # cyan
 white='\[\033[0m\]\[\033[38;5;7m\]'  # white

# Bold
 BLACK='\[\033[1m\]\[\033[38;5;0m\]'  # Black
   RED='\[\033[1m\]\[\033[38;5;1m\]'  # Red
 GREEN='\[\033[1m\]\[\033[38;5;2m\]'  # Green
YELLOW='\[\033[1m\]\[\033[38;5;3m\]'  # Yellow
  BLUE='\[\033[1m\]\[\033[38;5;4m\]'  # Blue
PURPLE='\[\033[1m\]\[\033[38;5;5m\]'  # Purple
  CYAN='\[\033[1m\]\[\033[38;5;6m\]'  # Cyan
 WHITE='\[\033[1m\]\[\033[38;5;7m\]'  # White

END="\[\033[0m\]"                     # Color Reset


echo -e "Hello BASH ${BASH_VERSION%.*}"
date

function _exit()              # Function to run upon exit of shell.
{
    echo -e "Bye BASH"
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

