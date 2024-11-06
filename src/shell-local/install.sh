#!/usr/bin/env bash
. ./library_scripts.sh

FEATURE_NAME=shell-local

title $FEATURE_NAME

if [ -n "$BASH_SCRIPT_PATH" ]; then
    add_feature_shell_file $FEATURE_NAME "$BASH_SCRIPT_PATH" "bash"
fi

if [ -n "$ZSH_SCRIPT_PATH" ]; then
    add_feature_shell_file $FEATURE_NAME "$ZSH_SCRIPT_PATH" "zsh"
fi
