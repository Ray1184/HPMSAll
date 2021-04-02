# Engine bridge project
cmake_minimum_required(VERSION 3.17)
project(HPMSApi)
set(CMAKE_CXX_STANDARD 14)

set(CMAKE_SHARED_LIBRARY_PREFIX)
set(CMAKE_STATIC_LIBRARY_PREFIX)
set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

set(DYNALO_VERSION 1.0.3)
set(GLM_VERSION 0.9.9.8)

include(../../cmake/Shared.cmake)

# Other libraries setup.
install_from_repo(https://github.com/g-truc/glm.git GLM ${GLM_VERSION} TRUE /)

include_directories(include)

set(SOURCES
        src/common/HPMSUtils.cpp
        src/common/HPMSMathUtils.cpp)

add_library(HPMSApi STATIC ${SOURCES})