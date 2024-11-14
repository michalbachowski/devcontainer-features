#!/bin/bash

# The 'test/_global' folder is a special test folder that is not tied to a single feature.
#
# This test file is executed against a running container constructed
# from the value of 'color_and_hello' in the tests/_global/scenarios.json file.
#
# The value of a scenarios element is any properties available in the 'devcontainer.json'.
# Scenarios are useful for testing specific options in a feature, or to test a combination of features.
# 
# This test can be run with the following command (from the root of this repo)
#    devcontainer features test --global-scenarios-only .

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

source test_scripts.sh

# check bash-prompt
FEATURE_NAME=bash-prompt
PROMPT_FILE_NAME="$COMMON_DIR/$FEATURE_NAME/prompt.bash"
USER_SHELL=bash

test_shell_features $FEATURE_NAME $PROMPT_FILE_NAME $USER_SHELL

check "When sourcing the [$user_rc_file_path] script file, the prompt takes effect" $USER_SHELL -i -c "[[ \"\$PROMPT_COMMAND\" =~ _update_ps1 ]] && exit 0 || exit 1"

# check bash-sensible

FEATURE_NAME=bash-sensible
SENSIBLE_FILE_NAME="$COMMON_DIR/$FEATURE_NAME/sensible.bash"
USER_SHELL=bash

test_shell_features $FEATURE_NAME "$SENSIBLE_FILE_NAME" "$USER_SHELL"

check "When sourcing the [$user_rc_file_path] script file, the sensible config takes effect" $USER_SHELL -i -c "test \"\$HISTIGNORE\" = '&:[ ]*:exit:ls:bg:fg:history:clear' || exit 1"

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
