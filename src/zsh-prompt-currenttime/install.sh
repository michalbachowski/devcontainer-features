#!/bin/bash

FEATURE_NAME=zsh-prompt-currenttime
SCRIPT_NAME='prompt-currenttime.zsh'
USER_SHELL=zsh

. ./library_scripts.bash

add_feature_shell_file "$FEATURE_NAME" "$SCRIPT_NAME" "$USER_SHELL"
