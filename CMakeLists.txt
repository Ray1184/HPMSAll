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

set(OGRE_BUILD $ENV{OGRE_BUILD})
set(OGRE_SRC $ENV{OGRE_SRC})

message(STATUS "Ogre build path: ${OGRE_BUILD}")
message(STATUS "Ogre src path: ${OGRE_SRC}")

#if ($ENV{OGRE_BUILD} STREQUAL "")
#    message(FATAL_ERROR "OGRE_BUILD environment variable must be set to build HPMS.")
#endif ()
#
#if ($ENV{OGRE_SRC} STREQUAL "")
#    message(FATAL_ERROR "OGRE_SRC environment variable must be set to build HPMS.")
#endif ()

add_definitions(-DCROSS_BUILD)
add_definitions(-DCOORD_SYSTEM_BLENDER)

if (NOT ${CMAKE_BUILD_TYPE} EQUAL "Release")
    add_definitions(-DFORCE_DEBUG_LOG)
endif ()

add_subdirectory(modules/Main)
add_subdirectory(modules/Extra)
