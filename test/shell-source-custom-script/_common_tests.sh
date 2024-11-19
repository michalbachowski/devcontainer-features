source test_scripts.sh

FEATURE_NAME=shell-source-custom-script
COMMON_DIR=/devcontainer-feature/michalbachowski

BASHRC_FILE_PATH="${COMMON_DIR}/bashrc"
BASH_SCRIPT_PATH=script.bash

ZSHRC_FILE_PATH="${COMMON_DIR}/zshrc"
ZSH_SCRIPT_PATH=script.zsh

# $USER defaults to `root`
if [ "$HAS_BASH" = "1" ]; then
    test_shell_features $FEATURE_NAME "$BASH_SCRIPT_PATH" "bash" "0"
    BASH_USER_RC_FILE_PATH=$user_rc_file_path
else
    check "The [$BASHRC_FILE_PATH] either DOES NOT exist or DOES NOT contain a reference to the [$BASH_SCRIPT_PATH] file" bash -c "test ! -f $BASHRC_FILE_PATH && exit 0; cat '$BASHRC_FILE_PATH' | grep '$BASH_SCRIPT_PATH' | grep -q source && exit 1"
fi

if [ "$HAS_ZSH" = "1" ]; then
    test_shell_features $FEATURE_NAME "$ZSH_SCRIPT_PATH" "zsh" "0"
    ZSH_USER_RC_FILE_PATH=$user_rc_file_path
else
    check "The [$ZSHRC_FILE_PATH] either DOES NOT exist or DOES NOT contain a reference to the [$ZSH_SCRIPT_PATH] file" bash -c "test ! -f $ZSHRC_FILE_PATH && exit 0; cat '$ZSHRC_FILE_PATH' | grep '$ZSH_SCRIPT_PATH' | grep -q source && exit 1"
fi
