# All modules project
cmake_minimum_required(VERSION 3.17)
project(HPMSAll)
set(CMAKE_CXX_STANDARD 14)

set(CMAKE_SHARED_LIBRARY_PREFIX)
set(CMAKE_STATIC_LIBRARY_PREFIX)

if (MSVC)
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /INCREMENTAL:NO")
endif ()

message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")

message(STATUS "Ogre root path: $ENV{OGRE_ROOT}")

if ($ENV{OGRE_ROOT} STREQUAL "")
    message(FATAL_ERROR "OGRE_ROOT environment variable must be set to build HPMS.")
endif ()

set(OGRE_ROOT $ENV{OGRE_ROOT})

add_subdirectory(modules/Main)
add_subdirectory(modules/Extra)
