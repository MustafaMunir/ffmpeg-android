#!/bin/bash

. abi_settings.sh $1 $2 $3

pushd ffmpeg

case $1 in
  armeabi-v7a | armeabi-v7a-neon)
    CPU='cortex-a8'
  ;;
  x86)
    CPU='i686'
  ;;
esac


#--extra-ldflags="-L${TOOLCHAIN_PREFIX}/lib $LDFLAGS" \
#--extra-libs="-lpng -lexpat -lm" \
#--extra-ldflags="-Wl,-rpath-link=${TOOLCHAIN_PREFIX}/lib -L${TOOLCHAIN_PREFIX}/lib $LDFLAGS" \
# --extra-libs="-lpng -lexpat -lm -lgcc" \
# -soname libffmpeg.so -shared -nostdlib -z,noexecstack -Bsymbolic --whole-archive --no-undefined -o libffmpeg.so --warn-once -Wl,-rpath-link=${TOOLCHAIN_PREFIX}/lib

# Investigate these options : --disable-network \ --disable-neon \ --disable-debug \ --disable-stripping \

echo $LDFLAGS

make clean

./configure \
--target-os="$TARGET_OS" \
--cross-prefix="$CROSS_PREFIX" \
--nm="$CROSS_PREFIX"nm \
--arch="$NDK_ABI" \
--cpu="$CPU" \
--enable-runtime-cpudetect \
--sysroot="$NDK_SYSROOT" \
--enable-pic \
--enable-libx264 \
--enable-libopencore-amrnb \
--enable-libass \
--enable-libfreetype \
--enable-libfribidi \
--enable-libmp3lame \
--enable-fontconfig \
--enable-pthreads \
--disable-debug \
--disable-ffserver \
--enable-version3 \
--enable-hardcoded-tables \
--disable-ffplay \
--disable-ffprobe \
--enable-gpl \
--enable-yasm \
--disable-doc \
--enable-shared \
--enable-static \
--enable-protocol=file \
--enable-avformat \
--enable-avcodec \
--enable-decoder=rawvideo \
--enable-decoder=mpeg4 \
--enable-decoder=h264 \
--enable-parser=h264 \
--enable-demuxer=h264 \
--disable-ffmpeg \
--disable-avdevice \
--disable-symver \
--disable-network \
--disable-neon \
--disable-debug \
--disable-stripping \
--enable-cross-compile \
--pkg-config="${2}/ffmpeg-pkg-config" \
--prefix="${2}/build/${1}" \
--extra-cflags="-I${TOOLCHAIN_PREFIX}/include $CFLAGS" \
--extra-ldflags="-Wl,-rpath-link=${TOOLCHAIN_PREFIX}/lib -L${TOOLCHAIN_PREFIX}/lib $LDFLAGS" \
--extra-libs="-lgcc -lpng -lexpat -lopencore-amrnb -lm -lc -lz -ldl -llog" \
--extra-cxxflags="$CXX_FLAGS" || exit 1

make -j${NUMBER_OF_CORES} && make install || exit 1

popd
