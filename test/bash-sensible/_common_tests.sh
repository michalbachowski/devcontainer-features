source test_scripts.sh

SENSIBLE_FILE_NAME=sensible.bash
USER_SHELL=bash

# $USER defailts to `root`
test_shell_features "$SENSIBLE_FILE_NAME" "$USER_SHELL" "$USER"

check "When sourcing the [$user_rc_file_path] script file, the prompt takes effect" $USER_SHELL -i -c "test \"\$HISTIGNORE\" = '&:[ ]*:exit:ls:bg:fg:history:clear' || exit 1"
