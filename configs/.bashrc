# Git branch
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
}

# Connect to ailabs workstation
function ailabs()
{
    ssh qhan@${1}.corp.ailabs.tw
}

# Clean scripts for docker
function clean_containers()
{
    containers=$(docker ps -q -f status=exited)
    if [ ! "$containers" ]; then 
        echo "no container to delete"
    else
        docker rm $containers
    fi
}

function clean_images()
{
    images=$(docker images -f "dangling=true" -q --no-trunc)
    if [ ! "$images" ]; then 
        echo "no image to delete"
    else
        docker rmi $images
    fi
}

function clean()
{
    case $1 in
        container)
            clean_containers ;;
        image)
            clean_images ;;
        *)
            clean_containers
            clean_images ;;
    esac
}

# Common ailas
alias p='ps -u qhan -F'
alias rm='rm -r'
alias ll='ls -liahF'
alias d='du -h -d 1 | sort -h'
alias h='cd ~'
alias b='cd ..'
alias q='exit'

# Profile editing
alias saverc='source ~/.bash_profile'
alias editrc='vim ~/.bash_profile'

alias jn='jupyter notebook --port 1028'

alias k8s='kubectl'

export CLICOLOR='true'
export LSCOLORS="gxfxcxdxcxegedabagacad"

export LD_LIBRARY_PATH=/usr/local/cuda/lib64/

# Kubernetes auto completion
source <(kubectl completion bash)
if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi

export PS1="\n\[\e[1;37m\][\[\e[1;31m\]\D{%Y.%m.%d.%a}\[\e[1;37m\]-\[\e[1;31m\]\t \[\e[1;32m\]\u\[\e[1;37m\]@\[\e[1;36m\]\h\[\e[1;37m\]: \[\e[1;35m\]\w\[\e[1;37m\]]\[\e[1;33m\]\[\e[1;34m\]\$(parse_git_branch)\[\e[1;33m\] \#\n\$ \[\e[m\]"
