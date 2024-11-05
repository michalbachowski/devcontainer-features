source test_scripts.sh

COMMON_DIR=/devcontainer-feature/michalbachowski

BASHRC_FILE_PATH="${COMMON_DIR}/bashrc"
BASH_SCRIPT_PATH=script.bash

ZSHRC_FILE_PATH="${COMMON_DIR}/zshrc"
ZSH_SCRIPT_PATH=script.zsh

# $USER defaults to `root`
if [ "$HAS_BASH" = "1" ]; then
    test_shell_features "$BASH_SCRIPT_PATH" "bash"
else
    check "The [$BASH_SCRIPT_PATH] either DOES NOT exist or DOES NOT contain a reference to the [$BASH_SCRIPT_PATH] file" bash -c "test ! -f $BASHRC_FILE_PATH && exit 0; cat '$BASHRC_FILE_PATH' | grep '$BASH_SCRIPT_PATH' | grep -q source"
fi

if [ "$HAS_ZSH" = "1" ]; then
    test_shell_features "$ZSH_SCRIPT_PATH" "zsh"
else
    check "The [$ZSH_SCRIPT_PATH] either DOES NOT exist or DOES NOT contain a reference to the [$ZSH_SCRIPT_PATH] file" bash -c "test ! -f $ZSHRC_FILE_PATH && exit 0; cat '$ZSHRC_FILE_PATH' | grep '$ZSH_SCRIPT_PATH' | grep -q source"
fi
