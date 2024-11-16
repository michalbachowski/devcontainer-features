source test_scripts.sh

CACHE_PATH=$COMMON_DIR/pre-commit-cache/cache

user="$(get_user)"

check "The [$CACHE_PATH] dir exists" bash -c "test -d $CACHE_PATH"
check "The [$CACHE_PATH] is owned by the [$user] user" bash -c "test \"\$(whoami)\" = \"$user\" && test -O $CACHE_PATH || exit 1"

check_env_is_set PRE_COMMIT_HOME $CACHE_PATH
