# All modules project
cmake_minimum_required(VERSION 3.17)
project(HPMSAll)
set(CMAKE_CXX_STANDARD 14)

set(CMAKE_SHARED_LIBRARY_PREFIX)
set(CMAKE_STATIC_LIBRARY_PREFIX)

set(OGRE_ROOT ${PROJECT_SOURCE_DIR}/../Ogre3D)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

add_subdirectory(modules/HPMSApi)
add_subdirectory(modules/HPMSBackendImpl)
add_subdirectory(modules/HPMSRuntime)
