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


include(../../cmake/Shared.cmake)

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
install_from_repo(https://github.com/mtrempoltsev/pods.git PODS ${PODS_VERSION} FALSE /include/)

install_from_repo(https://github.com/g-truc/glm.git GLM ${GLM_VERSION} TRUE /)

install_from_repo(https://github.com/vinniefalco/LuaBridge.git LUABRIDGE ${LUABRIDGE_VERSION} TRUE /Source/LuaBridge/)

# Ogre setup.
get_filename_component(BUILD_TYPE ${CMAKE_BINARY_DIR} NAME)
set(OGRE_BUILD ${OGRE_ROOT}/${BUILD_TYPE})
set(OGRE_H_0 ${OGRE_BUILD}/include)
set(OGRE_H_1 ${OGRE_BUILD}/Dependencies/include)
set(OGRE_H_2 ${OGRE_ROOT}/OgreMain/include)
set(OGRE_H_3 ${OGRE_ROOT}/Components/Overlay/include)
set(OGRE_H_4 ${OGRE_ROOT}/Components/Property/include)
set(OGRE_H_5 ${OGRE_ROOT}/RenderSystems/GL/include)
set(OGRE_H_6 ${OGRE_ROOT}/PlugIns/STBICodec/include)
set(OGRE_H_7 ${OGRE_ROOT}/RenderSystems/GL/include)

message(STATUS "Ogre includes: ")
message(STATUS "OGRE_H_0: ${OGRE_H_0}")
message(STATUS "OGRE_H_1: ${OGRE_H_1}")
message(STATUS "OGRE_H_2: ${OGRE_H_2}")
message(STATUS "OGRE_H_3: ${OGRE_H_3}")
message(STATUS "OGRE_H_4: ${OGRE_H_4}")
message(STATUS "OGRE_H_5: ${OGRE_H_5}")
message(STATUS "OGRE_H_6: ${OGRE_H_6}")
message(STATUS "OGRE_H_7: ${OGRE_H_7}")

include_directories(../HPMSApi/include)
include_directories(../HPMSBackendImpl/include)
include_directories(include)
include_directories(${OGRE_H_0})
include_directories(${OGRE_H_1})
include_directories(${OGRE_H_2})
include_directories(${OGRE_H_3})
include_directories(${OGRE_H_4})
include_directories(${OGRE_H_5})
include_directories(${OGRE_H_6})
include_directories(${OGRE_H_7})

set(SOURCES
        src/logic/CalcUtils.cpp
        src/logic/SectorUtils.cpp
        src/logic/LogicItemsCache.cpp
        src/logic/controllers/Collisor.cpp
        src/logic/controllers/Animator.cpp)

add_executable(HPMSRuntime src/HPMSRuntimeMain.cpp)
target_link_libraries(HPMSRuntime liblua LuaBridge HPMSBackendImpl)

# Installation.
add_custom_command(TARGET HPMSRuntime
        POST_BUILD
        # Copy dist to build.
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${PROJECT_SOURCE_DIR}/dist/ ${CMAKE_BINARY_DIR}/bin/
        # Copy scripts to build.
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${PROJECT_SOURCE_DIR}/../HPMSScripts/ ${CMAKE_BINARY_DIR}/bin/data/scripts/
        )
