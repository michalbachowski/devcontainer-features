#!/usr/bin/env bash
. ./library_scripts.sh

FEATURE_NAME=shell-local

if [ -n "$BASH_SCRIPT_PATH" ]; then
    add_feature_shell_file "$FEATURE_NAME (for bash_script_path)" "$BASH_SCRIPT_PATH" "bash"
fi

if [ -n "$ZSH_SCRIPT_PATH" ]; then
    add_feature_shell_file "$FEATURE_NAME (for zsh_script_path)" "$ZSH_SCRIPT_PATH" "zsh"
fi
