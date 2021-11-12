# All modules project
cmake_minimum_required(VERSION 3.17)
project(HPMSAll)
set(CMAKE_CXX_STANDARD 14)

set(CMAKE_SHARED_LIBRARY_PREFIX)
set(CMAKE_STATIC_LIBRARY_PREFIX)

set(BUILD_SHARED_LIBS OFF)

add_subdirectory(Api)
add_subdirectory(BackendImpl)
add_subdirectory(Runtime)
add_subdirectory(Tests)
