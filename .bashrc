#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
export CLICOLOR=1

# custom prompt!
# PS1='[\u@\h \W]\$ ' # Default
export PS1="\[$(tput setaf 1)\]\[$(tput bold)\]\n# \[$(tput sgr0)\]\[$(tput setaf 1)\]\u\[$(tput sgr0)\] @ \[$(tput setaf 2)\]\h\[$(tput sgr0)\] in \[$(tput setaf 3)\]\[$(tput bold)\]\w\[$(tput sgr0)\]\[$(tput setaf 7)\] [\t]\[$(tput setaf 6)\]\[$(tput bold)\]\n\\$ \[$(tput sgr0)\]"

# colourize ls
eval $(dircolors ~/.dircolors)

fw() { grep -Ern --color=auto "$1" . ;}
ff() { find . -type f | grep -E --color=auto "$1" ;}
fd() { find . -type d | grep -E --color=auto "$1" ;}

