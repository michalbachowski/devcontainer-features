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
    user="${3:-root}"

    check "binary exists" bash -c "test -f $script_path"
    check "binary executable" bash -c "test -x $script_path"
    check "binary is owned by $user" bash -c "test \"\$(whoami)\" = \"$user\" && test -O $script_path || exit 1"
    check "binary is available on PATH" bash -c "command -v $script_name >/dev/null || exit 1"
    check "binary is in correct version" bash -c "$script_name --version | grep $script_version"
}

function check_env_is_set
{
    local env_name="$1"
    local value="${2}"

    check_file_contains "$env_name=\"$value\""

    check "The [$env_name] prop is effectively set to [$value] (non-interactive, non-login shell)" bash -c "[ \"\$$env_name\" = \"$value\" ] || exit 1"
    check "The [$env_name] prop is effectively set to [$value] (interactive, non-login shell)" bash -i -c "[ \"\$$env_name\" = \"$value\" ] || exit 1"
    check "The [$env_name] prop is effectively set to [$value] (non-interactive, login shell)" bash -l -c "[ \"\$$env_name\" = \"$value\" ] || exit 1"
    check "The [$env_name] prop is effectively set to [$value] (interactive, login shell)" bash -i -l -c "[ \"\$$env_name\" = \"$value\" ] || exit 1"
}

function check_file_contains
{
    local value="$1"
    local path="${2:-$ENV_FILE_PATH}"
    check "The [$value] prop is set in the [$path] file" bash -c "cat $path | grep -q -F '$value'"
}
