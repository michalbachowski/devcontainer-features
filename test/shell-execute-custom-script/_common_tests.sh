source test_scripts.sh

FEATURE_NAME=shell-execute-custom-script
COMMON_DIR=/devcontainer-feature/michalbachowski
FEATURE_DIR=$COMMON_DIR/$FEATURE_NAME

BASH_SCRIPT="echo Bash > /dev/null"
ZSH_SCRIPT="echo Zsh > /dev/null"
COMMON_SCRIPT="alias git-uncommit-all-changes='git reset --soft \\\$(git merge-base HEAD \\\${BASE_BRANCH:-main})'"

BASHRC_FILE_PATH="${COMMON_DIR}/bashrc"
BASH_SCRIPT_PATH=$FEATURE_DIR/bash_scripts

ZSHRC_FILE_PATH="${COMMON_DIR}/zshrc"
ZSH_SCRIPT_PATH=$FEATURE_DIR/zsh_scripts

# $USER defaults to `root`

if [ "$HAS_BASH" = "1" ] || [ "$HAS_COMMON" = "1" ]; then
    check Debugging bash -c "cat $BASH_SCRIPT_PATH"
    test_shell_features $FEATURE_NAME "$BASH_SCRIPT_PATH" "bash"

    BASH_USER_RC_FILE_PATH=$user_rc_file_path
fi

if [ "$HAS_ZSH" = "1" ] || [ "$HAS_COMMON" = "1" ]; then
    check Debugging bash -c "cat $ZSH_SCRIPT_PATH"
    test_shell_features $FEATURE_NAME "$ZSH_SCRIPT_PATH" "zsh"

    ZSH_USER_RC_FILE_PATH=$user_rc_file_path
fi

if [ "$HAS_BASH" = "1" ]; then
    check "The [$BASH_SCRIPT_PATH] contains the [$BASH_SCRIPT] script" bash -c "cat $BASH_SCRIPT_PATH | grep -F '$BASH_SCRIPT'"
elif [ "$HAS_COMMON" = "0" ]; then
    check "The [$BASHRC_FILE_PATH] either DOES NOT exist or DOES NOT contain a reference to the [$BASH_SCRIPT_PATH] file" bash -c "test ! -f $BASHRC_FILE_PATH && exit 0; cat '$BASHRC_FILE_PATH' | grep '$BASH_SCRIPT_PATH' | grep source && exit 1"
fi

if [ "$HAS_ZSH" = "1" ]; then
    check "The [$ZSH_SCRIPT_PATH] contains the [$ZSH_SCRIPT] script" bash -c "cat $ZSH_SCRIPT_PATH | grep -F '$ZSH_SCRIPT'"
elif [ "$HAS_COMMON" = "0" ]; then
    check "The [$ZSHRC_FILE_PATH] either DOES NOT exist or DOES NOT contain a reference to the [$ZSH_SCRIPT_PATH] file" bash -c "test ! -f $ZSHRC_FILE_PATH && exit 0; cat '$ZSHRC_FILE_PATH' | grep '$ZSH_SCRIPT_PATH' | grep source && exit 1"
fi

if [ "$HAS_COMMON" = "1" ]; then
    check "The [$BASH_SCRIPT_PATH] contains the [$COMMON_SCRIPT] script" bash -c "cat $BASH_SCRIPT_PATH | grep -F \"$COMMON_SCRIPT\""
    check "The [$ZSH_SCRIPT_PATH] contains the [$COMMON_SCRIPT] script" bash -c "cat $ZSH_SCRIPT_PATH | grep -F \"$COMMON_SCRIPT\""
else
    check "The [$BASH_SCRIPT_PATH] either DOES NOT exist or DOES NOT contain the [$COMMON_SCRIPT] script" bash -c "test ! -f $BASH_SCRIPT_PATH && exit 0; cat $BASH_SCRIPT_PATH | grep -F \"$COMMON_SCRIPT\" && exit 1 || exit 0"
    check "The [$ZSH_SCRIPT_PATH] either DOES NOT exist or DOES NOT contain the [$COMMON_SCRIPT] script" bash -c "test ! -f $ZSH_SCRIPT_PATH && exit 0; cat $ZSH_SCRIPT_PATH | grep -F \"$COMMON_SCRIPT\" && exit 1 || exit 0"
fi
