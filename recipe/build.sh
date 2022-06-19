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
if [[ "${target_platform}" == "win-64" ]]; then
  extra_args="${extra_args} --target-os=mingw64"
  # For some reason this is necessary
  extra_args="${extra_args} --enable-cross-compile"
elif [[ "${target_platform}" == "linux-64" ]]; then
  extra_args="${extra_args} --enable-vaapi"
  extra_args="${extra_args} --enable-gnutls"
  extra_args="${extra_args} --enable-libx265"
  extra_args="${extra_args} --enable-libaom"
  extra_args="${extra_args} --enable-libfreetype"
  extra_args="${extra_args} --enable-libopenh264"
  extra_args="${extra_args} --enable-libmp3lame"
  extra_args="${extra_args} --enable-libsvtav1"
  extra_args="${extra_args} --enable-libvpx"
  extra_args="${extra_args} --enable-libx264"
  extra_args="${extra_args} --enable-libxml2"
  extra_args="${extra_args} --enable-zlib"
  extra_args="${extra_args} --enable-pthreads"
elif [[ "${target_platform}" == osx-* ]]; then
  if [[ "${target_platform}" == osx-arm64 ]]; then
    extra_args="${extra_args} --enable-neon"
  else
    extra_args="${extra_args} --disable-videotoolbox"
  fi
  extra_args="${extra_args} --enable-gnutls"
  extra_args="${extra_args} --enable-libx265"
  extra_args="${extra_args} --enable-libaom"
  extra_args="${extra_args} --enable-libfreetype"
  extra_args="${extra_args} --enable-libopenh264"
  extra_args="${extra_args} --enable-libmp3lame"
  extra_args="${extra_args} --enable-libsvtav1"
  extra_args="${extra_args} --enable-libvpx"
  extra_args="${extra_args} --enable-libx264"
  extra_args="${extra_args} --enable-libxml2"
  extra_args="${extra_args} --enable-zlib"
  extra_args="${extra_args} --enable-pthreads"
  # See https://github.com/conda-forge/ffmpeg-feedstock/pull/115
  # why this flag needs to be removed.
  sed -i.bak s/-Wl,-single_module// configure
fi

echo Current PKG_CONFIG=${PKG_CONFIG}
echo Current CC=${CC}
echo Current CXX=${CXX}
echo Current AR=${AR}
echo Current NM=${NM}
echo Current LD=${LD}
echo Current PREFIX=${PREFIX}

./configure \
        --prefix="${PREFIX}" \
        --cc=${CC} \
        --cxx=${CXX} \
        --nm=${NM} \
        --ar=${AR} \
        --ld=${LD} \
        --disable-doc \
        --disable-openssl \
        --enable-demuxer=dash \
        --enable-gpl \
        --enable-hardcoded-tables \
        ${extra_args} \
        --enable-pic \
        --enable-shared \
        --disable-static \
        --enable-version3 \
        --pkg-config=$BUILD_PREFIX/bin/pkg-config \
        || { cat ffbuild/config.log; exit 1; }

# Not sure why this isn't working.
# [[ "$target_platform" == "win-64" ]] && patch_libtool

# make -j${CPU_COUNT}
make V=1 VERBOSE=1
make install -j${CPU_COUNT}
