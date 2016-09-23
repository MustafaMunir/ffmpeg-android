#!/bin/bash

. abi_settings.sh $1 $2 $3

pushd opencore-amr-0.1.3

make clean

#   --prefix="${2}/build/${1}" \

LDFLAGS= "-Wl,-rpath-link=${TOOLCHAIN_PREFIX}/lib -L${TOOLCHAIN_PREFIX}/lib $LDFLAGS"

./configure \
  --with-pic \
  --with-sysroot="$NDK_SYSROOT" \
  --host="$NDK_TOOLCHAIN_ABI" \
  --enable-static \
  --disable-shared \
  --prefix="${TOOLCHAIN_PREFIX}" || exit 1

make -j${NUMBER_OF_CORES} && make install || exit 1

popd
