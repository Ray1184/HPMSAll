#!/bin/bash

PYTHON_EXE=$1
PROJECT_DIR=$2

SRC_DIR="${PROJECT_DIR}/modules/Main/Runtime"
BIN_DIR="${PROJECT_DIR}/Debug"

"${PYTHON_EXE}" deploy.py ${SRC_DIR} ${BIN_DIR}

EXIT_CODE=$?

echo "Task terminated with exit code ${EXIT_CODE}"

exit ${EXIT_CODE}

