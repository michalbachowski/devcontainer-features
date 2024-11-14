source test_scripts.sh

CACHE_PATH=$COMMON_DIR/sbt-cache/coursier

user="$(get_user)"

check "The [$CACHE_PATH] dir exists" bash -c "test -d $CACHE_PATH"
check "The [$CACHE_PATH] is owned by the [$user] user" bash -c "test \"\$(whoami)\" = \"$user\" && test -O $CACHE_PATH || exit 1"

check_env_is_set COURSIER_CACHE $CACHE_PATH
