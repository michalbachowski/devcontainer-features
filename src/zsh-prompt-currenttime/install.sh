#!/usr/bin/env bash

FEATURE_NAME=zsh-prompt-currenttime
SCRIPT_NAME='prompt-currenttime.zsh'
USER_SHELL=zsh

. ./library_scripts.sh

add_feature_shell_file "$FEATURE_NAME" "$SCRIPT_NAME" "$USER_SHELL"
