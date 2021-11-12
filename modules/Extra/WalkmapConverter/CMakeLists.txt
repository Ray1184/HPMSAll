# Tools project
cmake_minimum_required(VERSION 3.17)
project(HPMSWalkmapConverter)

set(CMAKE_SHARED_LIBRARY_PREFIX)
set(CMAKE_STATIC_LIBRARY_PREFIX)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_BUILD_TYPE})

set(GLM_VERSION 0.9.9.8)
set(PODS_VERSION master)

include(../../../cmake/Shared.cmake)


if (NOT DEFINED DEP_PATH)
    set(DEP_PATH ${CMAKE_BINARY_DIR}/_deps)
endif ()

# Other libraries setup.
install_from_repo(https://github.com/g-truc/glm.git GLM ${GLM_VERSION} TRUE /)

install_from_repo(https://github.com/mtrempoltsev/pods.git PODS ${PODS_VERSION} FALSE /include/)

ogre_include(${OGRE_ROOT})
get_filename_component(BUILD_TYPE ${CMAKE_BINARY_DIR} NAME)
set(OGRE_BUILD ${OGRE_ROOT}/${BUILD_TYPE})
set(OGRE_BIN ${OGRE_BUILD}/bin)
set(OGRE_BIN_2 ${OGRE_BUILD}/Dependencies/bin)

include_directories(../../Main/Api/include)
include_directories(../../Main/BackendImpl/include)
include_directories(include)

# Copy dist to build.
file(COPY ${PROJECT_SOURCE_DIR}/../../shared-dist/ DESTINATION ${CMAKE_BINARY_DIR}/bin/ext/)

set(SOURCES
        src/tools/HPMSWalkmapConverter.cpp)

add_executable(HPMSWalkmapConverter src/HPMSWalkmapConverterMain.cpp ${SOURCES})

target_link_libraries(HPMSWalkmapConverter HPMSBackendImpl)

# Installation.
string(TOLOWER ${CMAKE_BUILD_TYPE} BUILD_TYPE_LOWER)
add_custom_command(TARGET HPMSWalkmapConverter
        POST_BUILD
        # Copy Ogre dlls.
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${OGRE_BIN}/ ${CMAKE_BINARY_DIR}/bin/ext/
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${OGRE_BIN}/${BUILD_TYPE_LOWER}/ ${CMAKE_BINARY_DIR}/bin/ext/
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${OGRE_BIN_2}/ ${CMAKE_BINARY_DIR}/bin/ext/
        # Copy main exe.
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/ ${CMAKE_BINARY_DIR}/bin/ext/
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