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

extra_args=""
if [[ "${target_platform}" == "linux-64" ]]; then
  extra_args="${extra_args} --enable-vaapi"
elif [[ "${target_platform}" == osx-* ]]; then
  if [[ "${target_platform}" == osx-arm64 ]]; then
    extra_args="${extra_args} --enable-neon"
  else
    extra_args="${extra_args} --disable-videotoolbox"
  fi

  extra_args="${extra_args} --pkg-config=$BUILD_PREFIX/bin/pkg-config"
  # See https://github.com/conda-forge/ffmpeg-feedstock/pull/115
  # why this flag needs to be removed.
  sed -i.bak s/-Wl,-single_module// configure
fi

if [[ "${license_family}" == "gpl" ]]; then
    extra_args="${extra_args} --enable-gpl --enable-libx264 --enable-libx265"
else
    extra_args="${extra_args} --disable-gpl"
fi

./configure \
        --prefix="${PREFIX}" \
        --cc=${CC} \
        --cxx=${CXX} \
        --disable-doc \
        --disable-openssl \
        --enable-demuxer=dash \
        --enable-gnutls \
        --enable-hardcoded-tables \
        --enable-libfreetype \
        --enable-libopenh264 \
        ${extra_args} \
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
