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
  extra_args="--enable-vaapi"
  extra_args="${extra_args} --enable-gnutls"
  extra_args="${extra_args} --enable-libx265"
  extra_args="${extra_args} --enable-libaom"
elif [[ "${target_platform}" == osx-* ]]; then
  if [[ "${target_platform}" == osx-arm64 ]]; then
    extra_args="--enable-neon"
  else
    extra_args="--disable-videotoolbox"
  fi
  extra_args="${extra_args} --enable-gnutls"
  extra_args="${extra_args} --enable-libx265"
  extra_args="${extra_args} --enable-libaom"

  # See https://github.com/conda-forge/ffmpeg-feedstock/pull/115
  # why this flag needs to be removed.
  sed -i.bak s/-Wl,-single_module// configure
fi

./configure \
        --prefix="${PREFIX}" \
        --cc=${CC} \
        --disable-doc \
        --disable-openssl \
        --enable-demuxer=dash \
        --enable-gpl \
        --enable-hardcoded-tables \
        --enable-libfreetype \
        --enable-libopenh264 \
        ${extra_args} \
        --enable-libx264 \
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

[[ "$target_platform" == "win-64" ]] && patch_libtool

make -j${CPU_COUNT}
make install -j${CPU_COUNT}
