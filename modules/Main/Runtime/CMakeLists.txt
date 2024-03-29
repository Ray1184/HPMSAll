# Runtime project
cmake_minimum_required(VERSION 3.17)
project(HPMSRuntime)
set(CMAKE_CXX_STANDARD 14)

set(CMAKE_SHARED_LIBRARY_PREFIX)
set(CMAKE_STATIC_LIBRARY_PREFIX)

set(LUA_VERSION 5.3.2)
set(LUABRIDGE_VERSION 2.6)
set(PODS_VERSION master)
set(GLM_VERSION 0.9.9.8)


include(../../../cmake/Shared.cmake)
include(../../../cmake/OgreUtils.cmake)

# Other libraries setup.
install_from_repo(https://github.com/LuaDist/lua.git LUA ${LUA_VERSION} TRUE /src/)

# Lua configuration copy
if (NOT DEFINED DEP_PATH)
    set(DEP_PATH ${CMAKE_BINARY_DIR}/_deps)
endif ()

set(LUA_BUILD_PATH ${DEP_PATH}/lua-build)
set(LUA_SRC_PATH ${DEP_PATH}/lua-src/src)
configure_file(${LUA_BUILD_PATH}/luaconf.h ${LUA_SRC_PATH}/luaconf.h COPYONLY)

# Other libraries setup.
install_from_repo(https://github.com/museghost/pods.git PODS ${PODS_VERSION} FALSE /include/)

install_from_repo(https://github.com/g-truc/glm.git GLM ${GLM_VERSION} TRUE /)

install_from_repo(https://github.com/vinniefalco/LuaBridge.git LUABRIDGE ${LUABRIDGE_VERSION} TRUE /Source/LuaBridge/)

ogre_include($ENV{OGRE_SRC} $ENV{OGRE_BUILD})
include_directories(../Api/include)
include_directories(../BackendImpl/include)
include_directories(include)

# Copy dist to build.
if (MINGW)
    file(COPY ${PROJECT_SOURCE_DIR}/../../shared-dist/ DESTINATION ${CMAKE_BINARY_DIR}/bin/rt/)
endif()

file(COPY ${PROJECT_SOURCE_DIR}/dist/ DESTINATION ${CMAKE_BINARY_DIR}/bin/rt/)


set(SOURCES
        src/vm/HPMSLuaVM.cpp
        src/logic/interaction/HPMSCollisor.cpp
        src/states/HPMSLuaLogic.cpp
        src/states/HPMSGameState.cpp
        src/logic/gui/HPMSGuiText.cpp 
        src/logic/interaction/HPMSCollisionEnv.cpp 
        src/logic/ai/HPMSPathFinder.cpp)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin/rt/)

if (MSVC)
    message(STATUS "Executable for MSVC")
    add_executable(HPMSRuntime WIN32 src/HPMSRuntimeMain.cpp ${SOURCES})
else ()
    message(STATUS "Executable for MINGW, CLANG or UNIX like")
    add_executable(HPMSRuntime src/HPMSRuntimeMain.cpp ${SOURCES})
endif ()
target_link_libraries(HPMSRuntime liblua LuaBridge HPMSBackendImpl)

# Resources installation through python.
if (UNIX)
    set(BUILD_MODULE ${PROJECT_SOURCE_DIR}/build/deploy.sh)
    message(STATUS "Running sh ${BUILD_MODULE} python3 ${PROJECT_SOURCE_DIR}/../../../")
    execute_process(
           COMMAND ./${BUILD_MODULE} python3 ${PROJECT_SOURCE_DIR}/../../../
    )
else ()
    find_package(Python COMPONENTS Interpreter Development)
    set(BUILD_MODULE ${PROJECT_SOURCE_DIR}/build/deploy.py)
    message(STATUS "Running external build module: ${BUILD_MODULE} using Python: ${Python_EXECUTABLE}")

    execute_process(
           COMMAND ${Python_EXECUTABLE} ${BUILD_MODULE} ${PROJECT_SOURCE_DIR} ${CMAKE_BINARY_DIR}
    )

endif ()

if (WIN32)
    set(EXECUTABLE HPMSRuntime.exe)
else ()
    set(EXECUTABLE HPMSRuntime)
endif ()

# Installation.
#add_custom_command(TARGET HPMSRuntime
#        POST_BUILD
#        # Copy main exe.
#        COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${EXECUTABLE} ${CMAKE_BINARY_DIR}/bin/rt/
#        )
       