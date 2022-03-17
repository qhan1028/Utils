#
# Qhan's zsh theme
# Referenced from passion theme: https://github.com/ChesterYue/ohmyzsh-theme-passion
#


#
# gdate for macOS
# Reference: https://apple.stackexchange.com/questions/135742/time-in-milliseconds-since-epoch-in-the-terminal
#
if [[ "$OSTYPE" == "darwin"* ]]; then
    local c1="$fg_bold[yellow]"
    local c2="$fg_bold[red]"
    local color_reset="$reset_color";
    echo "\nHello ${c1}${USER}${color_reset}, ${c2}$(gdate +%Y.%m.%d) $(gdate +%H:%M:%S)${color_reset}"

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
    local color="%{$fg_no_bold[red]%}";                    # color in PROMPT need format in %{XXX%} which is not same with echo
    local date="$(date +%Y.%m.%d)";
    local time="$(date +%H:%M:%S)";
    local color_reset="%{$reset_color%}";
    echo "${color}${date}${color_reset}-${color}${time}${color_reset}";
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
        # Unknown.
    fi
    local yellow="%{$fg_no_bold[yellow]%}";        # color in PROMPT need format in %{XXX%} which is not same with echo
    local green="%{$fg_no_bold[green]%}";            # color in PROMPT need format in %{XXX%} which is not same with echo
    local color_reset="%{$reset_color%}";
    echo "${yellow}%n${color_reset}@${green}%m${color_reset}";
}


#
# Directory
#
function directory() {
    local color="%{$fg_bold[cyan]%}";
    # REF: https://stackoverflow.com/questions/25944006/bash-current-working-directory-with-replacing-path-to-home-folder
    local directory="${PWD/#$HOME/~}";
    local color_reset="%{$reset_color%}";
    echo "${color}${directory}${color_reset}";
}


#
# Git status
#
ZSH_THEME_GIT_PROMPT_PREFIX="[%{$fg_no_bold[magenta]%}";
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}]";
ZSH_THEME_GIT_PROMPT_DIRTY="🔥%{$reset_color%}";
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}";

function update_git_status() {
    GIT_STATUS=$(git_prompt_info);
}

function git_status() {
    echo "${GIT_STATUS}";
}


#
# Command status
#
function update_command_status() {
    local arrow="";
    local color_reset="%{$reset_color%}";
    local reset_font="%{$fg_no_bold[white]%}";
    COMMAND_RESULT=$1;
    export COMMAND_RESULT=$COMMAND_RESULT
    if $COMMAND_RESULT;
    then
        arrow="%{$fg_bold[green]%}❱";
    else
        arrow="%{$fg_bold[red]%}❱";
    fi
    COMMAND_STATUS="${arrow}${reset_font}${color_reset}";
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
    local color_reset="$reset_color";
    cmd="${color_cmd}${cmd}${color_reset}"

    # time
    local time="[$(date +%H:%M:%S)]"
    local color_time="$fg_no_bold[cyan]";
    time="${color_time}${time}${color_reset}";

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
    cost="${color_cost}${cost}${color_reset}";

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

PROMPT='[$(real_time) $(login_info) $(directory)] $(git_status)$NEWLINE$(command_status) ';


#
# Auto suggestion settings
#
ZSH_AUTOSUGGEST_STRATEGY=(history completion);
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20;
ZSH_AUTOSUGGEST_HISTORY_IGNORE="(cd|git) *";
ZSH_AUTOSUGGEST_COMPLETION_IGNORE="(cd|git) *";
