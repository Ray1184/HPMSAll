# Engine impl (OGRE) project
cmake_minimum_required(VERSION 3.17)
project(HPMSEngineImpl)
set(CMAKE_CXX_STANDARD 14)

set(CMAKE_SHARED_LIBRARY_PREFIX)
set(CMAKE_STATIC_LIBRARY_PREFIX)
set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

set(PODS_VERSION master)
set(GLM_VERSION 0.9.9.8)

if (NOT DEFINED DEP_PATH)
    set(DEP_PATH ${CMAKE_BINARY_DIR}/_deps)
endif ()


include(../../cmake/Shared.cmake)


# Other libraries setup.
install_from_repo(https://github.com/mtrempoltsev/pods.git PODS ${PODS_VERSION} FALSE /include/)

install_from_repo(https://github.com/g-truc/glm.git GLM ${GLM_VERSION} TRUE /)

# Ogre setup.
get_filename_component(BUILD_TYPE ${CMAKE_BINARY_DIR} NAME)
set(OGRE_BUILD ${OGRE_ROOT}/${BUILD_TYPE})
set(OGRE_BIN ${OGRE_BUILD}/bin)
set(OGRE_BIN_2 ${OGRE_BUILD}/Dependencies/bin)
set(OGRE_LIB ${OGRE_BUILD}/lib)
set(OGRE_LIB_2 ${OGRE_BUILD}/Dependencies/lib)
set(OGRE_H_0 ${OGRE_BUILD}/include)
set(OGRE_H_1 ${OGRE_BUILD}/Dependencies/include)
set(OGRE_H_2 ${OGRE_ROOT}/OgreMain/include)
set(OGRE_H_3 ${OGRE_ROOT}/Components/Overlay/include)
set(OGRE_H_4 ${OGRE_ROOT}/Components/Property/include)
set(OGRE_H_5 ${OGRE_ROOT}/RenderSystems/GL/include)
set(OGRE_H_6 ${OGRE_ROOT}/PlugIns/STBICodec/include)
set(OGRE_H_7 ${OGRE_ROOT}/RenderSystems/GL/include)


find_library(OGRE_MAIN
        NAMES OgreMain libOgreMain OgreMain.dll libOgreMain.dll OgreMain_d libOgreMain_d OgreMain_d.dll libOgreMain_d.dll
        PATHS ${OGRE_LIB}
        REQUIRED)

find_library(OGRE_OVERLAY
        NAMES OgreOverlay libOgreOverlay OgreOverlay.dll libOgreOverlay.dll OgreOverlay_d libOgreOverlay_d OgreOverlay_d.dll libOgreOverlay_d.dll
        PATHS ${OGRE_LIB}
        REQUIRED)

find_library(OGRE_PROPERTY
        NAMES OgreProperty libOgreProperty OgreProperty.dll libOgreProperty.dll OgreProperty_d libOgreProperty_d OgreProperty_d.dll libOgreProperty_d.dll
        PATHS ${OGRE_LIB}
        REQUIRED)

find_library(OGRE_CODEC
        NAMES Codec_STBI libCodec_STBI Codec_STBI.dll libCodec_STBI.dll Codec_STBI_d libCodec_STBI_d Codec_STBI_d.dll libCodec_STBI_d.dll
        PATHS ${OGRE_LIB}
        REQUIRED)

find_library(OGRE_RS
        NAMES RenderSystem_GL libRenderSystem_GL RenderSystem_GL.dll libRenderSystem_GL.dll RenderSystem_GL_d libRenderSystem_GL_d RenderSystem_GL_d.dll libRenderSystem_GL_d.dll
        PATHS ${OGRE_LIB}
        REQUIRED)

find_library(OGRE_GL
        NAMES OgreGLSupport libOgreGLSupport OgreGLSupport.dll libOgreGLSupport.dll OgreGLSupport_d libOgreGLSupport_d OgreGLSupport_d.dll libOgreGLSupport_d.dll
        PATHS ${OGRE_LIB}
        REQUIRED)

find_library(OGRE_SDL2
        NAMES SDL2 libSDL2 SDL2.dll libSDL2.dll SDL2d libSDL2d SDL2d.dll libSDL2d.dll
        PATHS ${OGRE_LIB_2}
        REQUIRED)

find_library(OGRE_SDL2MAIN
        NAMES SDL2main libSDL2main SDL2main.dll libSDL2main.dll SDL2maind libSDL2maind SDL2maind.dll libSDL2maind.dll
        PATHS ${OGRE_LIB_2}
        REQUIRED)

find_library(OGRE_ZLIB
        NAMES zlib libzlib zlib.dll libzlib.dll zlibd libzlibd zlibd.dll libzlibd.dll
        PATHS ${OGRE_LIB_2}
        REQUIRED)

find_library(OGRE_ZLIBSTATIC
        NAMES zlibstatic libzlibstatic zlibstatic.dll libzlibstatic.dll zlibstaticd libzlibstaticd zlibstaticd.dll libzlibstaticd.dll
        PATHS ${OGRE_LIB_2}
        REQUIRED)

find_library(OGRE_ZZIP
        NAMES zzip libzzip zzip.dll libzzip.dll zzipd libzzipd zzipd.dll libzzipd.dll
        PATHS ${OGRE_LIB_2}
        REQUIRED)

message(STATUS "Ogre dependencies: ")

message(STATUS "OGRE_MAIN: ${OGRE_MAIN}")
message(STATUS "OGRE_OVERLAY: ${OGRE_OVERLAY}")
message(STATUS "OGRE_PROPERTY: ${OGRE_PROPERTY}")
message(STATUS "OGRE_CODEC: ${OGRE_CODEC}")
message(STATUS "OGRE_RS: ${OGRE_RS}")
message(STATUS "OGRE_GL: ${OGRE_GL}")
message(STATUS "OGRE_SDL2: ${OGRE_SDL2}")
message(STATUS "OGRE_SDL2MAIN: ${OGRE_SDL2MAIN}")
message(STATUS "OGRE_ZLIB: ${OGRE_ZLIB}")
message(STATUS "OGRE_ZLIBSTATIC: ${OGRE_ZLIBSTATIC}")
message(STATUS "OGRE_ZZIP: ${OGRE_ZZIP}")

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
        src/input/HPMSInputHandler.cpp
        src/core/HPMSOgreContext.cpp
        src/thirdparty/Vector2D.cpp
        src/thirdparty/InputHelper.cpp
        src/resource/HPMSLuaScript.cpp
        src/resource/HPMSLuaScriptManager.cpp
        src/resource/HPMSWalkmap.cpp
        src/resource/HPMSWalkmapManager.cpp
        src/core/HPMSRenderToTexture.cpp
        src/core/HPMSEntityAdaptee.cpp
        src/core/HPMSAnimationAdaptee.cpp
        src/core/HPMSSceneNodeAdaptee.cpp
        src/core/HPMSCameraAdaptee.cpp
        src/core/HPMSBackgroundImageAdaptee.cpp
        src/core/HPMSOverlayImageAdaptee.cpp
        src/core/HPMSLightAdaptee.cpp
        src/core/HPMSSupplierAdaptee.cpp
        src/core/HPMSSimulatorAdaptee.cpp src/core/HPMSEngineFacade.cpp)

add_definitions(-DBACKEND_IMPL_NAME="Ogre 3D ${OGRE_VERSION}")

add_library(HPMSEngineImpl SHARED ${SOURCES})

#add_executable(HPMSEngineImpl src/Main.cpp ${SOURCES})
target_link_libraries(HPMSEngineImpl HPMSApi ${OGRE_MAIN} ${OGRE_OVERLAY} ${OGRE_SDL2})

# Installation.
string(TOLOWER ${CMAKE_BUILD_TYPE} BUILD_TYPE_LOWER)
add_custom_command(TARGET HPMSEngineImpl
        POST_BUILD
        # Copy dist to build.
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${PROJECT_SOURCE_DIR}/dist/ ${CMAKE_BINARY_DIR}/bin/
        # Copy Ogre dll files do build.
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${OGRE_BIN}/ ${CMAKE_BINARY_DIR}/bin/
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${OGRE_BIN}/${BUILD_TYPE_LOWER}/ ${CMAKE_BINARY_DIR}/bin/
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${OGRE_BIN_2}/ ${CMAKE_BINARY_DIR}/bin/
        # Delete folders and files.
        COMMAND ${CMAKE_COMMAND} -E rm -Rf ${CMAKE_BINARY_DIR}/bin/debug
        COMMAND ${CMAKE_COMMAND} -E rm -Rf ${CMAKE_BINARY_DIR}/bin/release
        COMMAND ${CMAKE_COMMAND} -E rm -Rf ${CMAKE_BINARY_DIR}/bin/minsizerel
        COMMAND ${CMAKE_COMMAND} -E rm -Rf ${CMAKE_BINARY_DIR}/bin/relwithdebinfo
        COMMAND ${CMAKE_COMMAND} -E rm ${CMAKE_BINARY_DIR}/bin/resources.cfg
        COMMAND ${CMAKE_COMMAND} -E rm ${CMAKE_BINARY_DIR}/bin/samples.cfg
        COMMAND ${CMAKE_COMMAND} -E rm ${CMAKE_BINARY_DIR}/bin/plugins.cfg
        COMMAND ${CMAKE_COMMAND} -E rm ${CMAKE_BINARY_DIR}/bin/tests.cfg
        )