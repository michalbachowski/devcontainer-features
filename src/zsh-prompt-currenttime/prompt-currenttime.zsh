# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export RPS1='%{$fg[gray]%}%D{%T}%{$reset_color%}'
