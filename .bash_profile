export PATH="$PATH:$HOME/scripts"
set -o noclobber
# common .bashrc to share among all machines
# Last update AH 1/28/2015


# --- Source global definitions --- #
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi


# --- Environmental variables --- #
export HISTSIZE=1000  # Changing history size
export HISTFILESIZE=1000  # Changing history size
export HISTCONTROL='ignoredups'  # Eliminate duplicates in history
export EDITOR='emacs -nw'  # Set default edit to emacs
#export PATH="$PATH:$HOME/scripts/linuxTools:$HOME/scripts/AHH_arrayTools/quantTools:$HOME/scripts/AHH_arrayTools/seqTools:$HOME/scripts/AHH_arrayTools/miscell"
#export PYTHONPATH="$PYTHONPATH:$HOME/scripts/AHH_arrayTools/pythonLib"
#export PYTHONSTARTUP="$HOME/scripts/dotfiles/python_init.py"
if [ "$(uname)" == "Darwin" ]; then  # Mac
    export LSCOLORS=GxFxCxDxBxegedabagaced  # Specify ls colors for Mac
fi


# --- Define aliases --- #

# - safety first - #
alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'
alias killall='killall -i'
alias gdragon='ssh peter@greendragon'
alias gseq='ssh peterfrick@greenseq'
alias corn='ssh frickpl@corn.stanford.edu'

# - shortcuts - #
alias whereami='echo $HOSTNAME'

# - git shortcuts - #
alias gs='git status'
alias gb='git branch'
alias gci='git commit -a'
alias gpm='git push -u origin master'
alias gcpm='git commit -a && git push -u origin master'


# --- Terminal display --- #

# - colors - #
BLACK='\[\e[0m\]'
RED='\[\e[0;31m\]'
GREEN='\[\e[0;32m\]'
YELLOW='\[\e[0;33m\]'
BLUE='\[\e[0;34m\]'
VIOLET='\[\e[0;35m\]'
CYAN='\[\e[0;36m\]'
GRAY='\[\e[0;37m\]'

# - bash prompt and title - #
PS1="$VIOLET[\j] $BLUE\w $BLACK"  # Set bash prompt style
if [ "$SSH_CONNECTION" ]; then
    PS1="\[\e]2;\u@\h\a\]$PS1"  # Set bash title if ssh'ed into remote machine
else
    PS1="\[\e]2;\w\007\]$PS1" # Set bash title to current directory if local
fi

# added by Anaconda 2.1.0 installer
export PATH="/Users/Peter/anaconda/bin:$PATH"
R_HOME="/Library/Frameworks/R.framework/Versions/Current/Resources/"; export R_HOME
