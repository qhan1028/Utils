PS1='\n\[\e[1;37m\][\[\e[1;32m\]\u\[\e[1;37m\]@\[\e[1;36m\]\h\[\e[1;37m\]: \[\e[1;35m\]\w\[\e[1;37m\]]\[\e[1;33m\] \#\n\[\e[1;33m\]\$ \[\e[m\]'

function ai()
{
    ssh qhan@${1}.corp.ailabs.tw
}

function csie()
{
    ssh b03902089@${1}.csie.ntu.edu.tw
}

function csie2()
{
    ssh r07944007@${1}.csie.ntu.edu.tw
}

function cmlab()
{
    ssh qhan@${1}.csie.ntu.edu.tw
}

function k8s()
{
    kubectl config use-context ${1}
}

alias p='ps -u qhan -F'
alias rm='rm -r'
alias ll='ls -liahF'
alias d='du -h -d 1 | sort -h'
alias h='cd ~'
alias b='cd ..'
alias q='exit'

alias saverc='source ~/.bash_profile'
alias editrc='vim ~/.bash_profile'

alias jn='jupyter notebook -y'

alias dockerclean='docker rm $(docker ps -q -f status=exited); docker rmi $(docker images -f "dangling=true" -q --no-trunc)'

alias k8s='kubectl'

export CLICOLOR='true'
export LSCOLORS="gxfxcxdxcxegedabagacad"

export LD_LIBRARY_PATH=/usr/local/cuda/lib64/

alias python='python3'

export PYTHONPATH="/usr/local/bin/python"

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

# Added by install_latest_perl_osx.pl
[ -r /Users/Qhan/.bashrc ] && source /Users/Qhan/.bashrc

# autocomplete
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi
