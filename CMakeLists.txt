# setup project
cmake_minimum_required(VERSION 3.9)
project(memflow-cmake-example VERSION 1.0 DESCRIPTION "memflow-cmake-example")

# load memflow project
include(ExternalProject)
set_directory_properties(PROPERTIES EP_PREFIX ${CMAKE_BINARY_DIR}/rs)
ExternalProject_Add(
    memflow
    GIT_REPOSITORY "https://github.com/memflow/memflow"
    GIT_SHALLOW true
    GIT_PROGRESS true
    GIT_TAG "0.2.0-beta2"
    CONFIGURE_COMMAND ""
    BUILD_COMMAND cargo build --all-features --workspace
    COMMAND cargo build --release --all-features --workspace
    BINARY_DIR "${CMAKE_BINARY_DIR}/rs/src/memflow"
    INSTALL_COMMAND ""
    LOG_BUILD ON)

find_package(Threads)

# create binary from /src
file(GLOB_RECURSE sample-cpp-sources "src/*.cpp")
file(GLOB_RECURSE sample-sources "src/*.c")
file(GLOB_RECURSE sample-headers "src/*.h")

add_executable(
    example
    ${sample-sources}
	${sample-cpp-sources}
    ${sample-headers})

add_dependencies(
    example
    memflow)

target_link_libraries(
    example
    debug "${CMAKE_BINARY_DIR}/rs/src/memflow/target/debug/libmemflow_ffi.a"
    optimized "${CMAKE_BINARY_DIR}/rs/src/memflow/target/release/libmemflow_ffi.a"
    ${CMAKE_THREAD_LIBS_INIT}
    ${CMAKE_DL_LIBS}
    m)

target_include_directories(
    example PUBLIC
    "${CMAKE_BINARY_DIR}/rs/src/memflow/memflow-ffi")
