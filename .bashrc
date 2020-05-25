#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
export CLICOLOR=1

# custom prompt!
# PS1='[\u@\h \W]\$ ' # Default
export PROMPT_COMMAND=set_prompt

set_prompt()
{
  # Capture exit code of last command
  local ex=$?

  local username='\[$(tput bold)\]\[\033[38;5;9m\]\u\[$(tput sgr0)\]'
  local at='@'
  local host='\[$(tput sgr0)\]\[\033[38;5;2m\]\h\[$(tput sgr0)\]'
  local in='in'
  local cwd='\[$(tput sgr0)\]\[$(tput bold)\]\[\033[38;5;12m\]\w\[$(tput sgr0)\]'
  local time='[ \t ]'
  local prompt='\[$(tput sgr0)\]\[\033[38;5;3m\]\\$\[$(tput sgr0)\] \[$(tput sgr0)\]'

  PS1=""

  [[ "$ex" -ne 0 ]] && PS1="\nexited with code: $ex\n"

  # Set prompt content
  PS1="$PS1\n$username $at $host $in $cwd $time\n$prompt"
}

# colourize ls
eval $(dircolors ~/.dircolors)

fw() { grep -Ern --color=auto "$1" . ;}
ff() { find . -type f | grep -E --color=auto "$1" ;}
fd() { find . -type d | grep -E --color=auto "$1" ;}

