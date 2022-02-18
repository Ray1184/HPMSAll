#! OGRE_INCLUDE
# Include all ogre dependencies.
#
# \arg:OGRE_SRC Ogre project src path.
#
function(OGRE_INCLUDE OGRE_SRC OGRE_BUILD)
    set(OGRE_H_0 ${OGRE_BUILD}/include)
    set(OGRE_H_1 ${OGRE_BUILD}/Dependencies/include)
    set(OGRE_H_2 ${OGRE_SRC}/OgreMain/include)
    set(OGRE_H_3 ${OGRE_SRC}/Components/Overlay/include)
    set(OGRE_H_4 ${OGRE_SRC}/Components/Property/include)
    set(OGRE_H_5 ${OGRE_SRC}/RenderSystems/GL/include)
    set(OGRE_H_6 ${OGRE_SRC}/PlugIns/STBICodec/include)
    set(OGRE_H_7 ${OGRE_SRC}/RenderSystems/GL/include)

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