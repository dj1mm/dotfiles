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

  local username='\e[1;31m\u'
  local at='\e[0m@'
  local host='\e[0;32m\h'
  local in='\e[0min'
  local cwd='\e[1;34m\w'
  local time='\e[0m[\t]'
  local prompt='\e[0;33m\$\e[0m'

  PS1=""

  # [[ "$ex" -ne 0 ]] && PS1="\n\n\e[1;31mexited with code: $ex\e[0m\n"

  # Set prompt content
  PS1="$PS1\n$username $at $host $in $cwd $time\n$prompt "
}

# colourize ls
eval $(dircolors ~/.dircolors)

fw() { grep -Ern --color=auto "$1" . ;}
ff() { find . -type f | grep -E --color=auto "$1" ;}
fd() { find . -type d | grep -E --color=auto "$1" ;}

