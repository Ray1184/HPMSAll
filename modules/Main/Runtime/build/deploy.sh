#!/bin/bash

PYTHON_EXE=$1
PROJECT_DIR=$2
BUILD_TYPE=$3

SRC_DIR="${PROJECT_DIR}/modules/Main/Runtime"
BIN_DIR="${PROJECT_DIR}/${BUILD_TYPE}"


echo "Command ${PYTHON_EXE} ${SRC_DIR}/build/deploy.py ${SRC_DIR} ${BIN_DIR}"

"${PYTHON_EXE}" "${SRC_DIR}/build/deploy.py" ${SRC_DIR} ${BIN_DIR}

EXIT_CODE=$?

echo "Task terminated with exit code ${EXIT_CODE}"

exit ${EXIT_CODE}

