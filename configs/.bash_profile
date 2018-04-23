PS1='\n\[\e[1;37m\][\[\e[1;32m\]\u\[\e[1;37m\]@\[\e[1;36m\]\h\[\e[1;37m\]: \[\e[1;35m\]\w\[\e[1;37m\]]\[\e[1;33m\] \#\n\[\e[1;33m\]\$ \[\e[m\]'

function bb()
{
    for i in $(seq 1 ${1}); do cd ..; done
}

function ai()
{
    ssh qhan@ws${1}.corp.ailabs.tw
}

function csie()
{
    ssh b03902089@linux${1}.csie.org
}

alias p='ps -u qhan -F'
alias rm='rm -rf'
alias ll='ls -liahF'
alias h='cd ~'
alias b='cd ..'
alias q='exit'
alias ns='nvidia-smi'

alias S='source ~/.bash_profile'
alias E='vim ~/.bash_profile'

export CLICOLOR='true'
export LSCOLORS="gxfxcxdxcxegedabagacad"

export LD_LIBRARY_PATH=/usr/local/cuda/lib64/

alias python='python3'

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH
