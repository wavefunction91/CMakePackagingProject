include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
include(cache/cache_add_dependency)
_cpp_setup_build_env("find_package")

set(src_dir ${test_prefix}/${test_number})
_cpp_add_test(
TITLE "Returns if target exists"
CONTENTS
    "include(dependency/cpp_find_package)"
    "add_library(dummy INTERFACE)"
    "_cpp_find_package(found ${src_dir} dummy \"\" \"\" \"\")"
)

set(src_dir ${test_prefix}/${test_number})
_cpp_dummy_cxx_package(${test_prefix})
_cpp_cache_add_dependency(${src_dir} dummy SOURCE_DIR ${test_prefix}/dummy)

_cpp_add_test(
TITLE "Returns false if not found"
CONTENTS
    "include(dependency/cpp_find_package)"
    "_cpp_find_package(found ${src_dir} dummy \"\" \"\" \"\")"
    "_cpp_assert_false(found)"
)

_cpp_install_dummy_cxx_package(${src_dir})

_cpp_add_test(
TITLE "Can find the package with config"
CONTENTS
    "include(dependency/cpp_find_package)"
    "_cpp_find_package(found ${src_dir} dummy \"\" \"\" ${src_dir}/install)"
    "_cpp_assert_true(found)"
)

set(src_dir ${test_prefix}/${test_number})
set(module ${src_dir}/Finddummy.cmake)
file(WRITE ${module}
"
find_path(DUMMY_INCLUDE_DIR a.hpp)
find_library(DUMMY_LIBRARY dummy)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    dummy DEFAULT_MSG
    DUMMY_LIBRARY
    DUMMY_INCLUDE_DIR
)
set(DUMMY_INCLUDE_DIRS \${DUMMY_INCLUDE_DIR})
set(DUMMY_LIBRARIES \${DUMMY_LIBRARY})
"
)
_cpp_naive_install_cxx_package(${src_dir})
_cpp_cache_add_dependency(
    ${src_dir}
    dummy
    SOURCE_DIR ${test_prefix}/dummy
    FIND_MODULE ${module}
)

_cpp_add_test(
TITLE "Can find via module"
CONTENTS
    "include(dependency/cpp_find_package)"
    "_cpp_find_package(found ${src_dir} dummy \"\" \"\" ${src_dir}/install)"
    "_cpp_assert_true(found)"
)

_cpp_add_test(
TITLE "Finding via module makes target"
CONTENTS
    "include(dependency/cpp_find_package)"
    "_cpp_find_package(found ${src_dir} dummy \"\" \"\" ${src_dir}/install)"
    "_cpp_is_target(made_dummy dummy)"
    "_cpp_assert_true(made_dummy)"

)
