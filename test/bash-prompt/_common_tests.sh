source test_scripts.sh

PROMPT_FILE_NAME=prompt.bash
USER_SHELL=bash

# $USER defaults to `root`
test_shell_features "$PROMPT_FILE_NAME" "$USER_SHELL" "$USER"

check "When sourcing the [$user_rc_file_path] script file, the prompt takes effect" $USER_SHELL -i -c "[[ \"\$PROMPT_COMMAND\" =~ _update_ps1 ]] && exit 0 || exit 1"
