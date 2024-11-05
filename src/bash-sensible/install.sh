#!/usr/bin/env bash

FEATURE_NAME=bash-sensible
SCRIPT_NAME='sensible.bash'
USER_SHELL=bash

. ./library_scripts.sh

add_feature_shell_file "$FEATURE_NAME" "$SCRIPT_NAME" "$USER_SHELL"
