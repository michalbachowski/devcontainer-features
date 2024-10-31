
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# PROMPT
source /etc/bash_completion.d/git-prompt

GIT_PS1_SHOWDIRTYSTATE=true

function PWD {
    pwd | awk -F\/ '{print $(NF-1),$(NF)}' | sed 's/ /\//'
}

function __venv() {
    if [ -z $VIRTUAL_ENV ]; then
        return;
    fi;

    local envname=`basename $VIRTUAL_ENV`;
    local printf_format=' (%s)';
    printf -- "$printf_format" "$envname";
}

function _update_ps1() {
    export PS1="\[\e[37m\],-\[\e[0m\]\[\e[37m\][\t]\[\e[0m\]\[\e[01;33m\] \[\e[31m\]\w\033[33m\]\$(__venv)\$(__git_ps1)\[\033[00m\]\n\[\e[37m\]'-\[\e[0m\]\[\e[01;32m\](\[\e[01;33m\]\#\[\e[01;32m\])\[\e[01;31m\]>\[\e[0m\]\$"

}

export PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
