#!/usr/bin/env bash

FEATURE_NAME=shell-execute-custom-script
BASH_SCRIPTS_FILE='bash_scripts'
ZSH_SCRIPTS_FILE='zsh_scripts'

. ./library_scripts.sh

title $FEATURE_NAME

copy_feature_files feature_cache_dir $FEATURE_NAME

BASH_SCRIPTS_PATH=$feature_cache_dir/$BASH_SCRIPTS_FILE
ZSH_SCRIPTS_PATH=$feature_cache_dir/$ZSH_SCRIPTS_FILE

if [ -n "$BASH_SCRIPT" ]; then
    echo "$BASH_SCRIPT" >> $BASH_SCRIPTS_PATH
    add_feature_shell_file "$FEATURE_NAME" "$BASH_SCRIPTS_PATH" bash
fi

if [ -n "$ZSH_SCRIPT" ]; then
    echo "$ZSH_SCRIPT" >> $ZSH_SCRIPTS_PATH
    add_feature_shell_file "$FEATURE_NAME" "$ZSH_SCRIPTS_PATH" zsh
fi
