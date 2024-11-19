source test_scripts.sh

FEATURE_NAME=shell-execute-custom-script
COMMON_DIR=/devcontainer-feature/michalbachowski
FEATURE_DIR=$COMMON_DIR/$FEATURE_NAME

BASH_SCRIPT="echo Bash > /dev/null"
ZSH_SCRIPT="echo Zsh > /dev/null"
BASHRC_FILE_PATH="${COMMON_DIR}/bashrc"
BASH_SCRIPT_PATH=$FEATURE_DIR/bash_scripts

ZSHRC_FILE_PATH="${COMMON_DIR}/zshrc"
ZSH_SCRIPT_PATH=$FEATURE_DIR/zsh_scripts

# $USER defaults to `root`
if [ "$HAS_BASH" = "1" ]; then
    test_shell_features $FEATURE_NAME "$BASH_SCRIPT_PATH" "bash"
    check "The [$BASH_SCRIPT_PATH] contains the [$BASH_SCRIPT] script" bash -c "cat $BASH_SCRIPT_PATH | grep -F '$BASH_SCRIPT'"

    BASH_USER_RC_FILE_PATH=$user_rc_file_path
else
    check "The [$BASHRC_FILE_PATH] either DOES NOT exist or DOES NOT contain a reference to the [$BASH_SCRIPT_PATH] file" bash -c "test ! -f $BASHRC_FILE_PATH && exit 0; cat '$BASHRC_FILE_PATH' | grep '$BASH_SCRIPT_PATH' | grep -q source && exit 1"
fi

if [ "$HAS_ZSH" = "1" ]; then
    test_shell_features $FEATURE_NAME "$ZSH_SCRIPT_PATH" "zsh"
    check "The [$ZSH_SCRIPT_PATH] contains the [$ZSH_SCRIPT] script" bash -c "cat $ZSH_SCRIPT_PATH | grep -F '$ZSH_SCRIPT'"

    ZSH_USER_RC_FILE_PATH=$user_rc_file_path
else
    check "The [$ZSHRC_FILE_PATH] either DOES NOT exist or DOES NOT contain a reference to the [$ZSH_SCRIPT_PATH] file" bash -c "test ! -f $ZSHRC_FILE_PATH && exit 0; cat '$ZSHRC_FILE_PATH' | grep '$ZSH_SCRIPT_PATH' | grep -q source && exit 1"
fi