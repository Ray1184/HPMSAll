#!/bin/bash

SRC_DIR=C:/Users/nicco/Desktop/Projects/HPMSAll/modules/Main/Runtime
BIN_DIR=C:/Users/nicco/Desktop/Projects/HPMSAll/cmake-build-debug
LOCAL_DIR=C:/Users/nicco/Desktop/Projects/HPMSAll/modules/Main/Runtime/build

cd ${LOCAL_DIR} || exit

C:/Users/nicco/AppData/Local/Programs/Python/Python39/python.exe ${SRC_DIR} ${BIN_DIR}
