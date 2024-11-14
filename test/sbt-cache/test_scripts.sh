# Import test library bundled with the devcontainer CLI
# See https://github.com/devcontainers/cli/blob/HEAD/docs/features/test.md#dev-container-features-test-lib
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

set -e

export COMMON_DIR=/devcontainer-feature/michalbachowski
export ENV_FILE_PATH="/etc/environment"

function get_user
{
    if [ "$NON_ROOT_USER" = "1" ]; then
        echo testuser
    else
        echo root
    fi
}

function get_homedir
{
    if [ "$NON_ROOT_USER" = "1" ]; then
        echo /home/$(get_user)
    else
        echo /root
    fi
}

function test_shell_features
{
    local feature_name="$1"
    local script_file_path="$2"
    local user_shell="$3"
    local script_file_must_exists="${4:-1}"

    local user="$(get_user)"
    local homedir="$(get_homedir)"

    FEATURE_CACHE_DIR=${COMMON_DIR}/$feature_name

    rc_file_name="${user_shell}rc"
    export rc_file_path=$COMMON_DIR/$rc_file_name
    export user_rc_file_path=$homedir/.$rc_file_name

    # Feature-specific tests
    # The 'check' command comes from the dev-container-features-test-lib. Syntax is...
    # check <LABEL> <cmd> [args...]

    check "Logging" bash -c "ls -la ${script_file_path} ${rc_file_path} ${user_rc_file_path}; echo -n $user' : [UID]='$UID'; [id cmd]='; id -u $user;  exit 0"
    if [ "$script_file_must_exists" = "1" ]; then
        check "The [$script_file_path] file exists" $user_shell -c "test -f $script_file_path"
        check "The [$script_file_path] file is owned by the [root] user" $user_shell -c "test \"$(stat -c '%u' $script_file_path)\" = \"$(id -u root)\" || exit 1"
    fi
    check "The $rc_file_name [$rc_file_path] file exists" $user_shell -c "test -f $rc_file_path"
    check "The $rc_file_name [$rc_file_path] file exists is owned by the [root] user" $user_shell -c "test \"$(stat -c '%u' $rc_file_path)\" = \"$(id -u root)\" || exit 1"
    check "The $rc_file_name [$rc_file_path] file contains a reference to the [$script_file_path] file" $user_shell -c "cat $rc_file_path | grep '$script_file_path' | grep source"
    check "The user's [$user] $rc_file_name [$user_rc_file_path] file exists" $user_shell -c "test -f $user_rc_file_path"
    check "The user's [$user] $rc_file_name [$user_rc_file_path] file exists is owned by the [$user] user" $user_shell -c "test \"\$(whoami)\" = \"$user\" && test -O $user_rc_file_path || exit 1"
    check "The user's [$user] $rc_file_name [$user_rc_file_path] file contains a reference to the feature's $rc_file_name [$rc_file_path] file" $user_shell -c "cat '$user_rc_file_path' | grep '$rc_file_path' | grep source"
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

function check_env_is_set
{
    env_name="$1"
    value="${2}"
    path="${3:-$ENV_FILE_PATH}"
    check "The [$env_name] prop is set in the [$path] and contains [$value] as a value" bash -c "cat $path | grep $env_name | grep -q '$value'"

    # for environment variables, check effective values
    if [ "$path" = "$ENV_FILE_PATH" ]; then
        check "The [$env_name] prop is effectively set to [$value]" bash -i -c "set -a; source /etc/environment; [ \"\$$env_name\" = \"$value\" ] || exit 1"
    fi
}
