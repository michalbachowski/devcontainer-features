#!/usr/bin/env bash

FEATURE_NAME=just-completion

. ./library_scripts.sh

title $FEATURE_NAME

# ZSH
if [ "$FOR_ZSH" = "true" ]; then
    if [ -n "$ZSH_AUTOCOMPLETE_PATH" ]; then
        JUST_ZSH_COMPLETION_PATH="$ZSH_AUTOCOMPLETE_PATH/_just"

        just --completions zsh > "$JUST_ZSH_COMPLETION_PATH"
        set_common_ownership "$JUST_ZSH_COMPLETION_PATH"
    else
        echo "The ZSH_AUTOCOMPLETE_PATH variable is not set!"
        echo "You can set it manually via containerEnv property,"
        echo "or by installing the [ghcr.io/michalbachowski/devcontainer-features/zsh-completion-setup] feature"
        exit 1
    fi
else
    echo "Zsh completion was not requested, skipping."
fi

# BASH
if [ "$FOR_BASH" = "true" ]; then
    BASH_COMPLETION_DIR=/etc/bash_completion.d
    JUST_BASH_COMPLETION_PATH="$BASH_COMPLETION_DIR/just"

    create_dir "$BASH_COMPLETION_DIR"

    just --completions bash > "$JUST_BASH_COMPLETION_PATH"
    set_common_ownership "$JUST_BASH_COMPLETION_PATH"
else
    echo "Bash completion was not requested, skipping."
fi

echo 'Done!'
