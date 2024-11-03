
function add_feature_shell_file
{
    set -e

    feature_name="$1"
    custom_script_path="$2"
    user_shell="$3"

    echo "Activating feature [$feature_name]"

    echo "User: ${_REMOTE_USER}     User home: ${_REMOTE_USER_HOME}"

    if [  -z "$_REMOTE_USER" ] || [ -z "$_REMOTE_USER_HOME" ]; then
        echo "***********************************************************************************"
        echo "*** Require _REMOTE_USER and _REMOTE_USER_HOME to be set (by dev container CLI) ***"
        echo "***********************************************************************************"
        exit 1
    fi

    COMMON_DIR=/devcontainer-feature/michalbachowski
    DEST_SCRIPT_PATH="$COMMON_DIR/$custom_script_path"
    DEST_SHELLRC_PATH="$COMMON_DIR/${user_shell}rc"

    user_shellrc_path="$_REMOTE_USER_HOME/.${user_shell}rc"

    if [ ! -d "$_REMOTE_USER_HOME" ]; then
        echo "The [$_REMOTE_USER_HOME] home directory for the [$_REMOTE_USER] user not found, aborting!"
        exit 1
    fi

    if [ -f "$DEST_SCRIPT_PATH" ]; then
        echo "The [$DEST_SCRIPT_PATH] file exists, skipping"
        exit 0
    fi

    # create common dir
    mkdir -p $COMMON_DIR
    chown -R $_REMOTE_USER $COMMON_DIR
    chmod -R 0555 $COMMON_DIR

    # copy custom script to common dir
    cp "$custom_script_path" "$DEST_SCRIPT_PATH"
    chown $_REMOTE_USER "$DEST_SCRIPT_PATH"
    chmod 0666 "$DEST_SCRIPT_PATH"

    # source custom script in custom <shell>rc
    echo "[[ \"\$-\" = *i* ]] && [ -f '$DEST_SCRIPT_PATH' ] && source '$DEST_SCRIPT_PATH'" >> $DEST_SHELLRC_PATH
    chown $_REMOTE_USER "$DEST_SHELLRC_PATH"
    chmod 0666 "$DEST_SHELLRC_PATH"

    # source custom <shell>rc in the user's .<shell>rc
    if [ ! -f "$user_shellrc_path" ] || ! cat "$user_shellrc_path" | grep "$DEST_SHELLRC_PATH" | grep -q source; then
        echo "[ -f '$DEST_SHELLRC_PATH' ] && source '$DEST_SHELLRC_PATH'" >> $user_shellrc_path
        chown $_REMOTE_USER "$user_shellrc_path"
        chmod 0666 "$user_shellrc_path"
    fi

    echo 'Done!'
}