# setup project
cmake_minimum_required(VERSION 3.9)
project(memflow-cmake-sample VERSION 1.0 DESCRIPTION "memflow-cmake-sample")

# load memflow project
include(ExternalProject)
set_directory_properties(PROPERTIES EP_PREFIX ${CMAKE_BINARY_DIR}/rs)
ExternalProject_Add(
    memflow
    GIT_REPOSITORY https://github.com/memflow/memflow
    GIT_SHALLOW true
    GIT_PROGRESS true
    GIT_TAG "0.1.3"
    CONFIGURE_COMMAND ""
    BUILD_COMMAND cargo build --all-features --workspace
    COMMAND cargo build --release --all-features --workspace
    BINARY_DIR "${CMAKE_BINARY_DIR}/rs/src/memflow"
    INSTALL_COMMAND ""
    LOG_BUILD ON)

find_package(Threads)

# create binary from /src
file(GLOB_RECURSE sample-sources "src/*.cpp")
file(GLOB_RECURSE sample-headers "src/*.h")

add_executable(
    memflow-cmake-sample
    ${sample-sources}
    ${sample-headers})

add_dependencies(
    memflow-cmake-sample
    memflow)

target_link_libraries(
    memflow-cmake-sample
    debug "${CMAKE_BINARY_DIR}/rs/src/memflow/target/debug/libmemflow_ffi.a"
    debug "${CMAKE_BINARY_DIR}/rs/src/memflow/target/debug/libmemflow_win32_ffi.a"
    optimized "${CMAKE_BINARY_DIR}/rs/src/memflow/target/release/libmemflow_win32_ffi.a"
    optimized "${CMAKE_BINARY_DIR}/rs/src/memflow/target/release/libmemflow_ffi.a"
    ${CMAKE_THREAD_LIBS_INIT}
    ${CMAKE_DL_LIBS})

target_include_directories(
    memflow-cmake-sample PUBLIC
    "${CMAKE_BINARY_DIR}/rs/src/memflow/memflow-ffi"
    "${CMAKE_BINARY_DIR}/rs/src/memflow/memflow-win32-ffi")
