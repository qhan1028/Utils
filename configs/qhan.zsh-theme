#
# Qhan's zsh theme
# Referenced from passion theme: https://github.com/ChesterYue/ohmyzsh-theme-passion
#

DATE_COLOR=red;
USER_COLOR=yellow;
HOST_COLOR=green;
PATH_COLOR=cyan;

GIT_COLOR=magenta;
PYENV_COLOR=magenta;
CMD_COLOR=white;


#
# gdate for macOS
# Reference: https://apple.stackexchange.com/questions/135742/time-in-milliseconds-since-epoch-in-the-terminal
#
if [[ "$OSTYPE" == "darwin"* ]]; then
    local c0="$reset_color";
    local c1="$fg_bold[${USER_COLOR}]"
    local c2="$fg_bold[${DATE_COLOR}]"
    local c3="$fg_bold[${HOST_COLOR}]"
    local HOSTNAME=$(hostname -s)
    echo "${c2}$(gdate +%Y.%m.%d) $(gdate +%H:%M:%S)${c0}, Hello ${c1}${USER}${c0}@${c3}${HOSTNAME}${c0}"

    {
        gdate > /dev/null
    } || {
        echo "\n$fg_bold[yellow]passsion.zsh-theme depends on cmd [gdate] to get current time in milliseconds$reset_color"
        echo "$fg_bold[yellow][gdate] is not installed by default in macOS$reset_color"
        echo "$fg_bold[yellow]to get [gdate] by running:$reset_color"
        echo "$fg_bold[green]brew install coreutils;$reset_color";
        echo "$fg_bold[yellow]\nREF: https://github.com/ChesterYue/ohmyzsh-theme-passion#macos\n$reset_color"
    }
fi


#
# Time
#
function real_time() {
    # local date="$(date +%Y.%m.%d)";
    local date="$(date +%m.%d)";
    local time="$(date +%H:%M:%S)";
    local c0="%{$reset_color%}";
    local c1="%{$fg_bold[${DATE_COLOR}]%}";                    # color in PROMPT need format in %{XXX%} which is not same with echo
    echo "${c1}${date}${c0}-${c1}${time}${c0}";
}


#
# Login info
#
function login_info() {
    local ip
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        # Linux
        ip="$(ifconfig | grep ^eth1 -A 1 | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | head -1)";
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        ip="$(ifconfig | grep ^en1 -A 4 | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | head -1)";
    elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows
    elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
    elif [[ "$OSTYPE" == "win32" ]]; then
        # I'm not sure this can happen.
    elif [[ "$OSTYPE" == "freebsd"* ]]; then
        # ...
    else
        # Unknown
    fi

    if [ -z $ip ]; then ip=💻; fi
    
    local c0="%{$reset_color%}";
    local c1="%{$fg_bold[${USER_COLOR}]%}";        # color in PROMPT need format in %{XXX%} which is not same with echo
    local c2="%{$fg_bold[${HOST_COLOR}]%}";            # color in PROMPT need format in %{XXX%} which is not same with echo
    echo "${c1}%n${c0}@${c2}${ip}${c0}";
}


#
# Directory
#
function directory() {
    # REF: https://stackoverflow.com/questions/25944006/bash-current-working-directory-with-replacing-path-to-home-folder
    local directory="${PWD/#$HOME/~}";
    local c0="%{$reset_color%}";
    local c1="%{$fg_bold[${PATH_COLOR}]%}";
    echo "${c1}${directory}${c0}";
}


#
# Git status
#
ZSH_THEME_GIT_PROMPT_PREFIX="[%{$fg_bold[${GIT_COLOR}]%}";
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}] ";
ZSH_THEME_GIT_PROMPT_DIRTY="🔥%{$reset_color%}";
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}";

function update_git_status() {
    GIT_STATUS=$(git_prompt_info);
}

function git_status() {
    echo "${GIT_STATUS}";
}


#
# Pyenv status
#
function update_virtualenv_status() {
    if [ ${VIRTUAL_ENV} ]; then
        local c0="%{$reset_color%}";
        local c1="%{$fg_bold[${PYENV_COLOR}]%}";
        VIRTUAL_ENV_STATUS="[${c1}$(basename ${VIRTUAL_ENV})${c0}] "
    else
        VIRTUAL_ENV_STATUS=""
    fi
}

function virtualenv_status() { 
    echo "${VIRTUAL_ENV_STATUS}"
}

export PYENV_VIRTUALENV_DISABLE_PROMPT=1


#
# Command status
#
function update_command_status() {
    local arrow="";
    local c0="%{$reset_color%}";
    local f0="%{$fg_no_bold[${CMD_COLOR}]%}";
    COMMAND_RESULT=$1;
    export COMMAND_RESULT=$COMMAND_RESULT
    if $COMMAND_RESULT;
    then
        arrow="%{$fg_bold[green]%}❱";
    else
        arrow="%{$fg_bold[red]%}❱";
    fi
    COMMAND_STATUS="${arrow}${f0}${c0}";
}
update_command_status true;

function command_status() {
    echo "${COMMAND_STATUS}";
}


#
# Output command execute after
#
output_command_execute_after() {
    if [ "$COMMAND_TIME_BEIGIN" = "-20200325" ] || [ "$COMMAND_TIME_BEIGIN" = "" ];
    then
        return 1;
    fi

    # cmd
    local cmd="${$(fc -l | tail -1)#*  }";
    local color_cmd="";
    if $1;
    then
        color_cmd="$fg_no_bold[green]";
    else
        color_cmd="$fg_bold[red]";
    fi
    local c0="$reset_color";
    cmd="${color_cmd}${cmd}${c0}"

    # time
    local time="[$(date +%H:%M:%S)]"
    local color_time="$fg_no_bold[cyan]";
    time="${color_time}${time}${c0}";

    # cost
    local time_end="$(current_time_millis)";
    local cost=$(bc -l <<<"${time_end}-${COMMAND_TIME_BEIGIN}");
    COMMAND_TIME_BEIGIN="-20200325"
    local length_cost=${#cost};
    if [ "$length_cost" = "4" ];
    then
        cost="0${cost}"
    fi
    cost="[cost ${cost}s]"
    local color_cost="$fg_no_bold[cyan]";
    cost="${color_cost}${cost}${c0}";

    echo -e "${time} ${cost} ${cmd}";
    echo -e "";
}


#
# Command execute before
# Reference: http://zsh.sourceforge.net/Doc/Release/Functions.html
# 
preexec() {
    COMMAND_TIME_BEIGIN="$(current_time_millis)";
}

current_time_millis() {
    local time_millis;
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        # Linux
        time_millis="$(date +%s.%3N)";
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        time_millis="$(gdate +%s.%3N)";
    elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows
    elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
    elif [[ "$OSTYPE" == "win32" ]]; then
        # I'm not sure this can happen.
    elif [[ "$OSTYPE" == "freebsd"* ]]; then
        # ...
    else
        # Unknown.
    fi
    echo $time_millis;
}


#
# Command execute after
#
# REF: http://zsh.sourceforge.net/Doc/Release/Functions.html
precmd() {
    # last_cmd
    local last_cmd_return_code=$?;
    local last_cmd_result=true;
    if [ "$last_cmd_return_code" = "0" ];
    then
        last_cmd_result=true;
    else
        last_cmd_result=false;
    fi

    # update_git_status
    update_git_status;

    # update_virtualenv_status
    update_virtualenv_status;

    # update_command_status
    update_command_status $last_cmd_result;

    # output command execute after
    # output_command_execute_after $last_cmd_result;

    echo -e ''
}


# set option
setopt PROMPT_SUBST;


#
# Timer
# Reference: https://stackoverflow.com/questions/26526175/zsh-menu-completion-causes-problems-after-zle-reset-prompt
#
TMOUT=1;

TRAPALRM() {
    # $(git_prompt_info) cost too much time which will raise stutters when inputting. so we need to disable it in this occurence.
    # if [ "$WIDGET" != "expand-or-complete" ] && [ "$WIDGET" != "self-insert" ] && [ "$WIDGET" != "backward-delete-char" ]; then
    # black list will not enum it completely. even some pipe broken will appear.
    # so we just put a white list here.
    if [ "$WIDGET" = "" ] || [ "$WIDGET" = "accept-line" ] ; then
        zle reset-prompt;
    fi
}


#
# Prompt
#
NEWLINE=$'\n';

PROMPT='[$(real_time) $(login_info) $(directory)] $(git_status)$(virtualenv_status)$NEWLINE$(command_status) ';


#
# Auto suggestion settings
#
ZSH_AUTOSUGGEST_STRATEGY=(history completion);
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20;
ZSH_AUTOSUGGEST_HISTORY_IGNORE="(cd|git) *";
ZSH_AUTOSUGGEST_COMPLETION_IGNORE="(cd|git) *";


#
# LS colors
#
CLICOLOR='true'
LSCOLORS="gxfxcxdxcxegedabagacad"
