#!/bin/bash

set -x

if [ "$(uname)" = "Darwin" ]; then
    LIB_FLAG='-dynamiclib'
    EXT='.dylib'
else
    LIB_FLAG='-shared'
    EXT='.so'
fi

mkdir -p build
cd build
EXEC_NAME=htdp
${FC} ${FFLAGS} ../${EXEC_NAME}.f -o ${EXEC_NAME}

# Install
mkdir -p ${PREFIX}/libexec
cp -fv ${EXEC_NAME} ${PREFIX}/libexec
