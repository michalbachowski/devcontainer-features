#!/bin/sh
set -e

echo "Activating feature 'bash-prompt'"

echo "User: ${_REMOTE_USER}     User home: ${_REMOTE_USER_HOME}"

if [  -z "$_REMOTE_USER" ] || [ -z "$_REMOTE_USER_HOME" ]; then
  echo "***********************************************************************************"
  echo "*** Require _REMOTE_USER and _REMOTE_USER_HOME to be set (by dev container CLI) ***"
  echo "***********************************************************************************"
  exit 1
fi

SCRIPT_NAME='prompt.bash'
SOURCE_SCRIPT_PATH="./$SCRIPT_NAME"

DEST_DIR=/devcontainer-feature/michalbachowski
DEST_SCRIPT_PATH="$DEST_DIR/$SCRIPT_NAME"
DEST_BASHRC_PATH="$DEST_DIR/bashrc"

user_bashrc_path="$_REMOTE_USER_HOME/.bashrc"

if [ ! -d "$_REMOTE_USER_HOME" ]; then
    echo "The [$_REMOTE_USER_HOME] home directory for the [$_REMOTE_USER] user not found, aborting!"
    exit 1
fi

if [ -f "$DEST_SCRIPT_PATH" ]; then
    echo "The [$DEST_SCRIPT_PATH] file exists, skipping"
    exit 0
fi

# create dest dir
mkdir -p $DEST_DIR
chown -R $_REMOTE_USER $DEST_DIR
chmod -R 0666 $DEST_DIR

# copy prompt source
cp "$SOURCE_SCRIPT_PATH" "$DEST_SCRIPT_PATH"
chown $_REMOTE_USER "$DEST_SCRIPT_PATH"
chmod 0666 "$DEST_SCRIPT_PATH"

# add prompt to custom bashrc
echo "[[ '\$-' = *i* ]] && [ -f '$DEST_SCRIPT_PATH' ] && source '$DEST_SCRIPT_PATH'" >> $DEST_BASHRC_PATH
chown $_REMOTE_USER "$DEST_BASHRC_PATH"
chmod 0666 "$DEST_BASHRC_PATH"

# add call to custom bashrc to the user's .bashrc
if [ ! -f "$user_bashrc_path" ] || ! cat "$user_bashrc_path" | grep "$DEST_BASHRC_PATH" | grep -q source; then
    echo "[ -f '$DEST_BASHRC_PATH' ] && source '$DEST_BASHRC_PATH'" >> $user_bashrc_path
    chown $_REMOTE_USER "$user_bashrc_path"
    chmod 0666 "$user_bashrc_path"
fi

echo 'Done!'
