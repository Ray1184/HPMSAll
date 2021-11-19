#!/bin/bash

PROJECT_DIR=$1
PYTHON_DIR=$2

SRC_DIR="${PROJECT_DIR}/modules/Main/Runtime"
BIN_DIR="${PROJECT_DIR}/Debug"
LOCAL_DIR="${PROJECT_DIR}/modules/Main/Runtime/build"
PYTHON_EXE="${PYTHON_DIR}/python"

cd ${LOCAL_DIR} || exit

${PYTHON_EXE} deploy.py ${SRC_DIR} ${BIN_DIR}

EXIT_CODE=$?

echo "Task terminated with exit code ${EXIT_CODE}"

read -p "Press any key to continue... " -n1 -s

exit ${EXIT_CODE}

