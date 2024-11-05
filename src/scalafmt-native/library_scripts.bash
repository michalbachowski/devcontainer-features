
function add_feature_shell_file
{
    set -e

    feature_name="$1"
    custom_script_path="$2"
    user_shell="$3"

    echo "Activating feature [$feature_name]"

    echo "User: ${_REMOTE_USER} [$(id -u $_REMOTE_USER)]     User home: ${_REMOTE_USER_HOME}"

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
    chown -R root $COMMON_DIR
    chmod -R 0555 $COMMON_DIR

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


# SOURCE: https://github.com/devcontainers-contrib/features

clean_download() {
    # The purpose of this function is to download a file with minimal impact on container layer size
    # this means if no valid downloader is found (curl or wget) then we install a downloader (currently wget) in a 
    # temporary manner, and making sure to 
    # 1. uninstall the downloader at the return of the function
    # 2. revert back any changes to the package installer database/cache (for example apt-get lists)
    # The above steps will minimize the leftovers being created while installing the downloader 
    # Supported distros:
    #  debian/ubuntu/alpine

    url=$1
    output_location=$2
    tempdir=$(mktemp -d)
    downloader_installed=""

    _apt_get_install() {
        tempdir=$1

        # copy current state of apt list - in order to revert back later (minimize contianer layer size) 
        cp -p -R /var/lib/apt/lists $tempdir 
        apt-get update -y
        apt-get -y install --no-install-recommends wget ca-certificates
    }

    _apt_get_cleanup() {
        tempdir=$1

        echo "removing wget"
        apt-get -y purge wget --auto-remove

        echo "revert back apt lists"
        rm -rf /var/lib/apt/lists/*
        rm -r /var/lib/apt/lists && mv $tempdir/lists /var/lib/apt/lists
    }

    _apk_install() {
        tempdir=$1
        # copy current state of apk cache - in order to revert back later (minimize contianer layer size) 
        cp -p -R /var/cache/apk $tempdir 

        apk add --no-cache  wget
    }

    _apk_cleanup() {
        tempdir=$1

        echo "removing wget"
        apk del wget 
    }
    # try to use either wget or curl if one of them already installer
    if type curl >/dev/null 2>&1; then
        downloader=curl
    elif type wget >/dev/null 2>&1; then
        downloader=wget
    else
        downloader=""
    fi

    # in case none of them is installed, install wget temporarly
    if [ -z $downloader ] ; then
        if [ -x "/usr/bin/apt-get" ] ; then
            _apt_get_install $tempdir
        elif [ -x "/sbin/apk" ] ; then
            _apk_install $tempdir
        else
            echo "distro not supported"
            exit 1
        fi
        downloader="wget"
        downloader_installed="true"
    fi

    if [ $downloader = "wget" ] ; then
        wget -q $url -O $output_location
    else
        curl -sfL $url -o $output_location 
    fi

    # NOTE: the cleanup procedure was not implemented using `trap X RETURN` only because
    # alpine lack bash, and RETURN is not a valid signal under sh shell
    if ! [ -z $downloader_installed  ] ; then
        if [ -x "/usr/bin/apt-get" ] ; then
            _apt_get_cleanup $tempdir
        elif [ -x "/sbin/apk" ] ; then
            _apk_cleanup $tempdir
        else
            echo "distro not supported"
            exit 1
        fi
    fi 

}


ensure_nanolayer() {
    # Ensure existance of the nanolayer cli program
    local variable_name=$1

    local required_version=$2

    local __nanolayer_location=""

    # If possible - try to use an already installed nanolayer
    if [ -z "${NANOLAYER_FORCE_CLI_INSTALLATION}" ]; then
        if [ -z "${NANOLAYER_CLI_LOCATION}" ]; then
            if type nanolayer >/dev/null 2>&1; then
                echo "Found a pre-existing nanolayer in PATH"
                __nanolayer_location=nanolayer
            fi
        elif [ -f "${NANOLAYER_CLI_LOCATION}" ] && [ -x "${NANOLAYER_CLI_LOCATION}" ] ; then
            __nanolayer_location=${NANOLAYER_CLI_LOCATION}
            echo "Found a pre-existing nanolayer which were given in env variable: $__nanolayer_location"
        fi

        # make sure its of the required version
        if ! [ -z "${__nanolayer_location}" ]; then
            local current_version
            current_version=$($__nanolayer_location --version)


            if ! [ $current_version == $required_version ]; then
                echo "skipping usage of pre-existing nanolayer. (required version $required_version does not match existing version $current_version)"
                __nanolayer_location=""
            fi
        fi

    fi

    # If not previuse installation found, download it temporarly and delete at the end of the script 
    if [ -z "${__nanolayer_location}" ]; then

        if [ "$(uname -sm)" = 'Linux x86_64' ] || [ "$(uname -sm)" = "Linux aarch64" ]; then
            tmp_dir=$(mktemp -d -t nanolayer-XXXXXXXXXX)

            clean_up () {
                ARG=$?
                rm -rf $tmp_dir
                exit $ARG
            }
            trap clean_up EXIT

            
            if [ -x "/sbin/apk" ] ; then
                clib_type=musl
            else
                clib_type=gnu
            fi

            tar_filename=nanolayer-"$(uname -m)"-unknown-linux-$clib_type.tgz

            # clean download will minimize leftover in case a downloaderlike wget or curl need to be installed
            clean_download https://github.com/devcontainers-contrib/cli/releases/download/$required_version/$tar_filename $tmp_dir/$tar_filename
            
            tar xfzv $tmp_dir/$tar_filename -C "$tmp_dir"
            chmod a+x $tmp_dir/nanolayer
            __nanolayer_location=$tmp_dir/nanolayer
      

        else
            echo "No binaries compiled for non-x86-linux architectures yet: $(uname -m)"
            exit 1
        fi
    fi

    # Expose outside the resolved location
    export ${variable_name}=$__nanolayer_location

}
