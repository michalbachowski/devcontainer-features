#!/bin/bash

FEATURE_NAME=bash-sensible
SCRIPT_NAME='sensible.bash'
USER_SHELL=bash

. ./library_scripts.bash

add_feature_shell_file "$FEATURE_NAME" "$SCRIPT_NAME" "$USER_SHELL"
