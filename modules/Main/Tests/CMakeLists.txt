# Runtime project
cmake_minimum_required(VERSION 3.17)
project(HPMSTests)
set(CMAKE_CXX_STANDARD 14)

set(CMAKE_SHARED_LIBRARY_PREFIX)
set(CMAKE_STATIC_LIBRARY_PREFIX)

add_executable(HPMSTests src/HPMSTestLibraries.cpp)
