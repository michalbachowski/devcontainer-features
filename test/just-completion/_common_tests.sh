source test_scripts.sh

FEATURE_NAME=just-completion
ZSH_COMPLETION_FILE_NAME="$COMMON_DIR/zsh-completion-setup/completions/_just"
BASH_COMPLETION_FILE_NAME="/etc/bash_completion.d/just"
USER_SHELL=bash

function test_file
{
    local file_path="$1"
    local should_be_missing="$2"
    local user="$(get_user)"

    if [ "$should_be_missing" = "1" ]; then
        check "The [$file_path] file DOES NOT exist" bash -c "test ! -f $file_path"
    else
        check "The [$file_path] file exists" bash -c "test -f $file_path"
        check "The [$file_path] file exists is owned by the [$user] user" bash -c "test \"$(stat -c '%u' $file_path)\" = \"$(id -u $user)\" || exit 1"
    fi
}

echo "NO_ZSH=[$NO_ZSH]; NO_BASH=[$NO_BASH]"
test_file "$ZSH_COMPLETION_FILE_NAME" "$NO_ZSH"
test_file "$BASH_COMPLETION_FILE_NAME" "$NO_BASH"
