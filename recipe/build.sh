#!/bin/bash

# unset the SUBDIR variable since it changes the behavior of make here
unset SUBDIR

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  EXTRA_CONFIGURE_OPTIONS="--enable-cross-compile"
fi

./configure \
        --prefix="${PREFIX}" \
        --cc=${CC} \
        --disable-doc \
        --disable-openssl \
        --enable-avresample \
        --enable-gnutls \
        --enable-gpl \
        --enable-hardcoded-tables \
        --enable-libfreetype \
        --enable-libopenh264 \
        --enable-libx264 \
        --enable-pic \
        --enable-pthreads \
        --enable-shared \
        --enable-static \
        --enable-version3 \
        --enable-zlib \
	--enable-libmp3lame \
	$EXTRA_CONFIGURE_OPTIONS

make -j${CPU_COUNT}
make install -j${CPU_COUNT}
