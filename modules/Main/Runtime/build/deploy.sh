#!/bin/bash

SRC_DIR=C:/Users/nicco/Desktop/Projects/HPMSAll/modules/Main/Runtime
BIN_DIR=C:/Users/nicco/Desktop/Projects/HPMSAll/cmake-build-debug
LOCAL_DIR=C:/Users/nicco/Desktop/Projects/HPMSAll/modules/Main/Runtime/build

cd ${LOCAL_DIR} || exit

python deploy.py ${SRC_DIR} ${BIN_DIR}
