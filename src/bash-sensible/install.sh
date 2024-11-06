#!/usr/bin/env bash

FEATURE_NAME=bash-sensible
SCRIPT_NAME='sensible.bash'
USER_SHELL=bash

. ./library_scripts.sh

title $FEATURE_NAME
copy_feature_files feature_cache_dir $FEATURE_NAME
add_feature_shell_file $FEATURE_NAME "${feature_cache_dir}/$SCRIPT_NAME" "$USER_SHELL"
