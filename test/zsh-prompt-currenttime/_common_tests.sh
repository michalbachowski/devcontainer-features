source test_scripts.sh

FEATURE_NAME=zsh-prompt-currenttime
PROMPT_FILE_NAME="$COMMON_DIR/$FEATURE_NAME/prompt-currenttime.zsh"
USER_SHELL=zsh

test_shell_features $FEATURE_NAME "$PROMPT_FILE_NAME" "$USER_SHELL"

check "When sourcing the [$user_rc_file_path] script file, the prompt takes effect" $USER_SHELL -i -c "echo \$RPS1 | grep -q reset_color"
