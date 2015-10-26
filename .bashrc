#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
export CLICOLOR=1

# custom prompt!
# PS1='[\u@\h \W]\$ ' # Default
export PS1='\[\e[1;31m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;34m\]\w\[\e[0m\]\$ '

# colourize ls
eval $(dircolors ~/.dircolors)
