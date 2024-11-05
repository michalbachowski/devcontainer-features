# Import test library bundled with the devcontainer CLI
# See https://github.com/devcontainers/cli/blob/HEAD/docs/features/test.md#dev-container-features-test-lib
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

set -e

function test_shell_features
{
    script_file_name="$1"
    user_shell="$2"


    if [ "$NON_ROOT_USER" = "1" ]; then
        USER=vscode
        HOMEDIR=/home/$USER
    else
        USER=root
        HOMEDIR=/root
    fi

    COMMON_DIR=/devcontainer-feature/michalbachowski

    script_file_path=$COMMON_DIR/$script_file_name
    rc_file_name="${user_shell}rc"
    export rc_file_path=$COMMON_DIR/$rc_file_name
    export user_rc_file_path=$HOMEDIR/.$rc_file_name

    # Feature-specific tests
    # The 'check' command comes from the dev-container-features-test-lib. Syntax is...
    # check <LABEL> <cmd> [args...]

    check "Logging" bash -c "ls -la ${script_file_path} ${rc_file_path} ${user_rc_file_path}; echo -n $USER' : [UID]='$UID'; [id cmd]='; id -u $USER;  exit 0"
    check "The $script_file_name [$script_file_path] file exists" $user_shell -c "test -f $script_file_path"
    check "The $script_file_name [$script_file_path] file is owned by the [root] user" $user_shell -c "test \"$(stat -c '%u' $script_file_path)\" = \"$(id -u root)\" || exit 1"
    check "The $rc_file_name [$rc_file_path] file exists" $user_shell -c "test -f $rc_file_path"
    check "The $rc_file_name [$rc_file_path] file exists is owned by the [root] user" $user_shell -c "test \"$(stat -c '%u' $rc_file_path)\" = \"$(id -u root)\" || exit 1"
    check "The $rc_file_name [$rc_file_path] file contains a reference to the $script_file_name [$script_file_path] file" $user_shell -c "cat $rc_file_path | grep '$script_file_path' | grep source"
    check "The user's [$USER] $rc_file_name [$user_rc_file_path] file exists" $user_shell -c "test -f $user_rc_file_path"
    check "The user's [$USER] $rc_file_name [$user_rc_file_path] file exists is owned by the [$USER] user" $user_shell -c "test \"\$(whoami)\" = \"$USER\" && test -O $user_rc_file_path || exit 1"
    check "The user's [$USER] $rc_file_name [$user_rc_file_path] file contains a reference to the feature's $rc_file_name [$rc_file_path] file" $user_shell -c "cat '$user_rc_file_path' | grep '$rc_file_path' | grep source"
}

function test_binary_feature
{
    script_path="$1"
    script_name="$(basename $script_path)"
    script_version="$2"

    check "binary exists" bash -c "test -f $script_path"
    check "binary executable" bash -c "test -x $script_path"
    check "binary is owned by root:root" bash -c "ls -l $script_path | grep  'root root'"
    check "binary is available on PATH" bash -c "command -v $script_name >/dev/null || exit 1"
    check "binary is in correct version" bash -c "$script_name --version | grep $script_version"
}