#!/bin/bash
set -ex

# unset the SUBDIR variable since it changes the behavior of make here
unset SUBDIR

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  if [[ "$ARCH" == "64" ]]; then
    ARCH=x86_64
  fi
  case "$target_platform" in
    linux-*)
      OS=linux
      ;;
    osx-*)
      OS=darwin
      ;;
    *)
      echo "unknown OS for cross compile"
      exit 1
      ;;
  esac
  EXTRA_CONFIGURE_OPTIONS="--enable-cross-compile --arch=$ARCH --target-os=$OS --cross-prefix=$HOST- --host-cc=$CC_FOR_BUILD"
fi

if [[ "${target_platform}" == "linux-64" ]]; then
    extra_codecs="${extra_codecs} --enable-vaapi"
    extra_codecs="${extra_codecs} --enable-nvenc"
    extra_codecs="${extra_codecs} --enable-cuda-nvcc"
fi

./configure \
        --prefix="${PREFIX}" \
        --cc=${CC} \
        --disable-doc \
        --disable-openssl \
        --enable-avresample \
        --enable-demuxer=dash \
        --enable-gnutls \
        --enable-gpl \
        --enable-hardcoded-tables \
        --enable-libfreetype \
        --enable-libopenh264 \
        ${extra_codecs} \
        --enable-libx264 \
        --enable-libx265 \
        --enable-libaom \
        --enable-libsvtav1 \
        --enable-libxml2 \
        --enable-libvpx \
        --enable-pic \
        --enable-pthreads \
        --enable-shared \
        --disable-static \
        --enable-version3 \
        --enable-zlib \
        --enable-libmp3lame \
        --pkg-config=$BUILD_PREFIX/bin/pkg-config \
        $EXTRA_CONFIGURE_OPTIONS || { cat ffbuild/config.log; exit 1; }

make -j${CPU_COUNT}
make install -j${CPU_COUNT}
