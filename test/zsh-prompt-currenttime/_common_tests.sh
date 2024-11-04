source test_scripts.sh

PROMPT_FILE_NAME=prompt-currenttime.zsh
USER_SHELL=zsh

# $USER defaults to `root`
test_shell_features "$PROMPT_FILE_NAME" "$USER_SHELL" "$USER"

check "When sourcing the [$user_rc_file_path] script file, the prompt takes effect" $USER_SHELL -i -c "echo \$RPS1 | grep -q reset_color"
