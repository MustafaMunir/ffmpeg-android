#!/bin/bash

. abi_settings.sh $1 $2 $3

pushd opencore-amr-0.1.3

make clean

./configure \
  --with-sysroot="$NDK_SYSROOT" \
  --host="$NDK_TOOLCHAIN_ABI" \
  --enable-static \
  --disable-shared \
  --build=arm-linux \
  --prefix="${TOOLCHAIN_PREFIX}" || exit 1

make -j${NUMBER_OF_CORES} install || exit 1

popd
