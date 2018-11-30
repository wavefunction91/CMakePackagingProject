include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("get_from_gh")


set(cpp_repo "github.com/CMakePackagingProject/CMakePackagingProject")

set(output ${test_prefix}/${test_number}/cpp.tar.gz)
_cpp_add_test(
TITLE "Basic usage"
CONTENTS
    "include(recipes/cpp_get_from_gh)"
    "_cpp_get_from_gh(${output} \"\" ${cpp_repo})"
    "_cpp_assert_exists(${output})"
)

set(output ${test_prefix}/${test_number}/cppdocs.tar.gz)
_cpp_add_test(
TITLE "Get a particular branch"
CONTENTS
    "include(recipes/cpp_get_from_gh)"
    "_cpp_get_from_gh(${output} \"\" ${cpp_repo} BRANCH docs)"
    "_cpp_assert_exists(${output})"
)

_cpp_add_test(
TITLE "Crashes if github.com is not in URL"
SHOULD_FAIL REASON  "github.com\" not contained in string \"organization/repo\""
CONTENTS
    "include(recipes/cpp_get_from_gh)"
    "_cpp_get_from_gh(output \"\" organization/repo)"
)