source test_scripts.sh

FEATURE_NAME=bash-sensible
SENSIBLE_FILE_NAME="$COMMON_DIR/$FEATURE_NAME/sensible.bash"
USER_SHELL=bash

# $USER defaults to `root`
test_shell_features $FEATURE_NAME "$SENSIBLE_FILE_NAME" "$USER_SHELL"

check "When sourcing the [$user_rc_file_path] script file, the prompt takes effect" $USER_SHELL -i -c "test \"\$HISTIGNORE\" = '&:[ ]*:exit:ls:bg:fg:history:clear' || exit 1"
