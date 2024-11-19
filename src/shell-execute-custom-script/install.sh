#!/usr/bin/env bash

FEATURE_NAME=shell-execute-custom-script
BASH_SCRIPTS_FILE='bash_scripts'
ZSH_SCRIPTS_FILE='zsh_scripts'

. ./library_scripts.sh

title $FEATURE_NAME

copy_feature_files feature_cache_dir $FEATURE_NAME

BASH_SCRIPTS_PATH=$feature_cache_dir/$BASH_SCRIPTS_FILE
ZSH_SCRIPTS_PATH=$feature_cache_dir/$ZSH_SCRIPTS_FILE

function add_script
{
    local path="$1"
    local shell="$2"
    local script="$3"

    if [ -z "$script" ]; then
        echo "The script is empty, skipping"
        return
    fi

    if [ -f "$path" ] && cat "$path" | grep "$script"; then
        echo "The [$path] path already contains the script [$script], skipping"
        return
    fi

    echo "Adding script [$script] to [$path]"
    echo "$script" >> "$path"
    add_feature_shell_file "$FEATURE_NAME" "$path" $shell
}

add_script $BASH_SCRIPTS_PATH bash "$BASH_SCRIPT"
add_script $BASH_SCRIPTS_PATH bash "$COMMON_SCRIPT"
add_script $ZSH_SCRIPTS_PATH zsh "$ZSH_SCRIPT"
add_script $ZSH_SCRIPTS_PATH zsh "$COMMON_SCRIPT"
