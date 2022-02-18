# Tools project
cmake_minimum_required(VERSION 3.17)
project(HPMSWalkmapConverter)

set(CMAKE_SHARED_LIBRARY_PREFIX)
set(CMAKE_STATIC_LIBRARY_PREFIX)

set(GLM_VERSION 0.9.9.8)
set(PODS_VERSION master)

include(../../../cmake/Shared.cmake)


if (NOT DEFINED DEP_PATH)
    set(DEP_PATH ${CMAKE_BINARY_DIR}/_deps)
endif ()

# Other libraries setup.
install_from_repo(https://github.com/g-truc/glm.git GLM ${GLM_VERSION} TRUE /)

install_from_repo(https://github.com/mtrempoltsev/pods.git PODS ${PODS_VERSION} FALSE /include/)

ogre_include($ENV{OGRE_SRC} $ENV{OGRE_BUILD})

set(OGRE_BIN $ENV{OGRE_BUILD}/bin)
set(OGRE_BIN_2 $ENV{OGRE_BUILD}/Dependencies/bin)

include_directories(../../Main/Api/include)
include_directories(../../Main/BackendImpl/include)
include_directories(include)

# Copy dist to build.
if (MINGW)
    file(COPY ${PROJECT_SOURCE_DIR}/../../shared-dist/ DESTINATION ${CMAKE_BINARY_DIR}/bin/ext/)
endif()

set(SOURCES
        src/tools/HPMSWalkmapConverter.cpp)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin/ext/)
add_executable(HPMSWalkmapConverter src/HPMSWalkmapConverterMain.cpp ${SOURCES})

target_link_libraries(HPMSWalkmapConverter HPMSBackendImpl)

if (WIN32)
    set(EXECUTABLE HPMSWalkmapConverter.exe)
else ()
    set(EXECUTABLE HPMSWalkmapConverter)
endif ()

# Installation.
string(TOLOWER ${CMAKE_BUILD_TYPE} BUILD_TYPE_LOWER)
add_custom_command(TARGET HPMSWalkmapConverter
        POST_BUILD
        # Copy Ogre dlls.
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${OGRE_BIN}/ ${CMAKE_BINARY_DIR}/bin/ext/
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${OGRE_BIN}/${BUILD_TYPE_LOWER}/ ${CMAKE_BINARY_DIR}/bin/ext/
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${OGRE_BIN_2}/ ${CMAKE_BINARY_DIR}/bin/ext/
        # Copy main exe.
        #COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${EXECUTABLE} ${CMAKE_BINARY_DIR}/bin/ext/
        # Delete folders and files.
        COMMAND ${CMAKE_COMMAND} -E rm -Rf ${CMAKE_BINARY_DIR}/bin/ext/debug
        COMMAND ${CMAKE_COMMAND} -E rm -Rf ${CMAKE_BINARY_DIR}/bin/ext/release
        COMMAND ${CMAKE_COMMAND} -E rm -Rf ${CMAKE_BINARY_DIR}/bin/ext/minsizerel
        COMMAND ${CMAKE_COMMAND} -E rm -Rf ${CMAKE_BINARY_DIR}/bin/ext/relwithdebinfo
        COMMAND ${CMAKE_COMMAND} -E rm ${CMAKE_BINARY_DIR}/bin/ext/resources.cfg
        COMMAND ${CMAKE_COMMAND} -E rm ${CMAKE_BINARY_DIR}/bin/ext/samples.cfg
        COMMAND ${CMAKE_COMMAND} -E rm ${CMAKE_BINARY_DIR}/bin/ext/plugins.cfg
        COMMAND ${CMAKE_COMMAND} -E rm ${CMAKE_BINARY_DIR}/bin/ext/tests.cfg
        )