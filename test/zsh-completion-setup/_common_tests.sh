source test_scripts.sh

FEATURE_NAME=zsh-autocomplete
PROMPT_FILE_NAME="$COMMON_DIR/$FEATURE_NAME/autocomplete.zsh"
USER_SHELL=zsh

test_shell_features $FEATURE_NAME "$PROMPT_FILE_NAME" "$USER_SHELL"

check "ZSH_AUTOCOMPLETE_PATH env is set" zsh -i -c 'echo $ZSH_AUTOCOMPLETE_PATH; test -n "$ZSH_AUTOCOMPLETE_PATH"'
check "Sources dir exists" zsh -i -c 'test -d "$ZSH_AUTOCOMPLETE_PATH"'
check "When sourcing the [$user_rc_file_path] script file, the prompt takes effect" $USER_SHELL -i -c 'echo "$fpath" | grep -q "$ZSH_AUTOCOMPLETE_PATH"'
