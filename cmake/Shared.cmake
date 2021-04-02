# Common build functions

include(FetchContent)

#! INSTALL_FROM_REPO
# Checkout and install an external library from remote repository.
#
# \arg:REPO Repository URL.
# \arg:NAME Library name.
# \arg:BRANCH Branch name.
# \flag:BUILD Build subdir flag (use false if CMakeLists.txt is not present or for header-only libraries).
# \arg:INCLUDE_SUFFIXES The suffixes to append to include directory.
#
function(INSTALL_FROM_REPO REPO NAME BRANCH BUILD INCLUDE_SUFFIXES)
    message(STATUS "Installing external library ${NAME}")
    FetchContent_Declare(
            ${NAME}
            GIT_REPOSITORY ${REPO}
            GIT_TAG ${BRANCH}
    )

    string(TOLOWER ${NAME} LIB_NAME_LOWERCASE)
    string(CONCAT SRC_DIR ${LIB_NAME_LOWERCASE}_SOURCE_DIR)
    string(CONCAT BIN_DIR ${LIB_NAME_LOWERCASE}_BINARY_DIR)
    FetchContent_GetProperties(${NAME})
    if (NOT ${LIB_NAME_LOWERCASE}_POPULATED)
        FetchContent_Populate(${NAME})
        if (BUILD)
            message(STATUS "Building ${NAME}")
            add_subdirectory(${${SRC_DIR}} ${${BIN_DIR}})
            message(STATUS "Building ${NAME} - done")
        endif ()
    endif ()
    foreach (INCLUDE_SUFFIX ${INCLUDE_SUFFIXES})
        set(INCLUDE_DIR ${${SRC_DIR}}${INCLUDE_SUFFIX})
        include_directories(${INCLUDE_DIR})
        message(STATUS "Include directory for ${NAME}: ${INCLUDE_DIR}")
        message(STATUS "Installing external library ${NAME} - done")
    endforeach ()

endfunction()


#! CAT
# Copy lines from a file and past into another file.
#
# \arg:IN_FILE Input file.
# \arg:OUT_FILE Output file.
#
function(CAT IN_FILE OUT_FILE)
    file(READ ${IN_FILE} CONTENTS)
    file(APPEND ${OUT_FILE} "${CONTENTS}")
endfunction()

#! LIST_PATHS
# Lists all resources in folder and add prefix foreach.
#
# \arg:FOLDER Folder to check.
# \arg:OUT_FILE Prefix to add foreach file path.
# \arg:ABSOLUTE_PATH Absolute path flag (use true if you want to add complete path, false for filename only).
# \arg:OUTPUT Output variable where result is stored.
#
function(LIST_PATHS FOLDER PREFIX ABSOLUTE_PATH OUTPUT)
    file(GLOB FILE_LIST ${FOLDER}/*)
    set(TMP_OUT "")
    foreach (FILE_DEF ${FILE_LIST})
        set(FILE_DEF_1 ${FILE_DEF})
        if (NOT ABSOLUTE_PATH)
            get_filename_component(FILE_DEF_1 ${FILE_DEF} NAME)
        endif ()
        set(FILE_DEF_2 ${PREFIX}${FILE_DEF_1})
        list(APPEND TMP_OUT ${FILE_DEF_2})
    endforeach ()
    set(${OUTPUT} ${TMP_OUT} PARENT_SCOPE)

endfunction()