#! OGRE_INCLUDE
# Include all ogre dependencies.
#
# \arg:OGRE_ROOT Ogre project root path.
#
function(OGRE_INCLUDE OGRE_ROOT)
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

    include_directories(${OGRE_H_0})
    include_directories(${OGRE_H_1})
    include_directories(${OGRE_H_2})
    include_directories(${OGRE_H_3})
    include_directories(${OGRE_H_4})
    include_directories(${OGRE_H_5})
    include_directories(${OGRE_H_6})
    include_directories(${OGRE_H_7})
endfunction()