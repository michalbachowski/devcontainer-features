export DCFMB_COMMON_DIR=/devcontainer-feature/michalbachowski
export ENV_FILE_PATH=/etc/environment

function ensure_common_dir
{
    # create common dir
    mkdir -p $DCFMB_COMMON_DIR
    chown -R root $DCFMB_COMMON_DIR
    chmod -R 0555 $DCFMB_COMMON_DIR

}

function copy_feature_files
{
    local feature_name="$1"
    local feature_files_source_path="${2:-$(pwd)}"
    local env_name_suffix="$(echo $feature_name | tr '[:lower:]' '[:upper:]' | tr '-' '_')"

    local feature_files_dest_path="${DCFMB_COMMON_DIR}/$1"

    ensure_common_dir

    if [ -d "$feature_files_dest_path" ]; then
        echo "The feature [$feature_name] directory has been cached already, skipping"
        return
    fi

    echo "For the [$feature_name] feature copying source [$feature_files_source_path] to the [$feature_files_dest_path] feature cache path"
    cp -r "$feature_files_source_path" "$feature_files_dest_path"
    chown root "$feature_files_dest_path"
    chmod 0555 "$feature_files_dest_path"

    set_env "DCFMB_${env_name_suffix}_PATH" "$feature_files_path"

    echo "Final state of the [$feature_name] feature cache dir is:"
    ls -la "$feature_files_dest_path"
}

function add_feature_shell_file
{
    set -e

    local feature_name="$1"
    local custom_script_path="$2"
    local user_shell="$3"

    echo "Activating feature [$feature_name]"

    echo "User: ${_REMOTE_USER} [$(id -u $_REMOTE_USER)]     User home: ${_REMOTE_USER_HOME}"

    if [  -z "$_REMOTE_USER" ] || [ -z "$_REMOTE_USER_HOME" ]; then
        echo "***********************************************************************************"
        echo "*** Require _REMOTE_USER and _REMOTE_USER_HOME to be set (by dev container CLI) ***"
        echo "***********************************************************************************"
        exit 1
    fi

    ensure_common_dir

    local DEST_SCRIPT_PATH="$DCFMB_COMMON_DIR/$custom_script_path"
    local DEST_SHELLRC_PATH="$DCFMB_COMMON_DIR/${user_shell}rc"

    local user_shellrc_path="$_REMOTE_USER_HOME/.${user_shell}rc"

    if [ ! -d "$_REMOTE_USER_HOME" ]; then
        echo "The [$_REMOTE_USER_HOME] home directory for the [$_REMOTE_USER] user not found, aborting!"
        exit 1
    fi

    if [ -f "$DEST_SCRIPT_PATH" ]; then
        echo "The [$DEST_SCRIPT_PATH] file exists, skipping"
        exit 0
    fi

    if [ -z "$custom_script_path" ]; then
        echo "The custom script path is empty, aborting!"
        exit 1
    fi

    # if the custom script exists, copy it to the common dir
    if [ -f "$custom_script_path" ]; then
        echo "Copying [$custom_script_path] to [$DEST_SCRIPT_PATH]"
        cp "$custom_script_path" "$DEST_SCRIPT_PATH"
        chown root "$DEST_SCRIPT_PATH"
        chmod 0555 "$DEST_SCRIPT_PATH"
        echo "The details of the [$DEST_SCRIPT_PATH] are: $(ls -la $DEST_SCRIPT_PATH)"
    else
        echo "The [$custom_script_path] file does not exists."
        echo "Moving forward, since it might be mounted during container run."
    fi

    # source custom script in custom <shell>rc
    echo "Adding the call (source) of the [$DEST_SCRIPT_PATH] custom script to the [$DEST_SHELLRC_PATH] common shell config file."
    echo "[[ \"\$-\" = *i* ]] && [ -f '$DEST_SCRIPT_PATH' ] && source '$DEST_SCRIPT_PATH'" >> $DEST_SHELLRC_PATH
    chown root "$DEST_SHELLRC_PATH"
    chmod 0555 "$DEST_SHELLRC_PATH"
    echo "The details of the [$DEST_SHELLRC_PATH] are: $(ls -la $DEST_SHELLRC_PATH)"

    # source custom <shell>rc in the user's .<shell>rc
    if [ ! -f "$user_shellrc_path" ] || ! cat "$user_shellrc_path" | grep "$DEST_SHELLRC_PATH" | grep -q source; then
        echo "Adding the call (source) of the [$DEST_SHELLRC_PATH] common shell config to the [$user_shellrc_path] user shell config file."
        echo "[ -f '$DEST_SHELLRC_PATH' ] && source '$DEST_SHELLRC_PATH'" >> $user_shellrc_path
        chown $_REMOTE_USER "$user_shellrc_path"
        chmod 0666 "$user_shellrc_path"
        echo "The details of the [$user_shellrc_path] are: $(ls -la $user_shellrc_path)"
    else
        echo "The call (source) of the [$DEST_SHELLRC_PATH] common shell config has already been added to the [$user_shellrc_path] user shell config file, skipping."
    fi

    echo 'Done!'
}

function set_env
{
    env_name="$1"
    value="${2:-$CERT_PATH}"

    if ! cat $ENV_FILE_PATH | grep $env_name | grep "$value"; then
        echo "Setting environment variable [$env_name] to [$value] in [$ENV_FILE_PATH]"
        echo "${env_name}=\"$value\"" >> $ENV_FILE_PATH
    else
        echo "The [$ENV_FILE_NAME] contains already the [$env_name] variable with the [$value] value";
    fi
}
