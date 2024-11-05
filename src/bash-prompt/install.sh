#!/usr/bin/env bash

FEATURE_NAME=bash-prompt
SCRIPT_NAME='prompt.bash'
USER_SHELL=bash

. ./library_scripts.sh

add_feature_shell_file "$FEATURE_NAME" "$SCRIPT_NAME" "$USER_SHELL"
