#!/bin/bash

set -x

if [ "$(uname)" = "Darwin" ]; then
    LIB_FLAG='-dynamiclib'
    EXT='.dylib'
    
    # Hack, use my own compileron the Mac. I could not make the
    # conda fortran work as it expects libgfortran 4 which is
    # incompatible with LAPACK.
    
    FC=/usr/local/bin/gfortran
    FFLAGS=''
    LDFLAGS=''
else
    LIB_FLAG='-shared'
    EXT='.so'
fi

# Build
rm -rfv build
mkdir -p build
cd build

EXEC_NAME=htdp

${FC} ${FFLAGS} ../${EXEC_NAME}.f -o ${EXEC_NAME}

if [ "$(uname)" = "Darwin" ]; then
    # Make library paths be relative
    for dep in libgfortran.3 libquadmath.0 libgcc_s.1; do 
        /usr/bin/install_name_tool -change /usr/local/lib/${dep}.dylib \
            @rpath/${dep}.dylib ${EXEC_NAME}
    done
fi

# Install
mkdir -p ${PREFIX}/libexec
cp -fv ${EXEC_NAME} ${PREFIX}/libexec
