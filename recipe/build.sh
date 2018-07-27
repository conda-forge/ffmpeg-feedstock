#!/bin/bash

# unset the SUBDIR variable since it changes the behavior of make here
unset SUBDIR

./configure \
        --prefix="${PREFIX}" \
        --disable-doc \
        --disable-openssl \
        --enable-shared \
        --enable-static \
        --extra-cflags="-Wall -g -m64 -pipe -O3 -march=x86-64 -fPIC" \
        --extra-cxxflags="-Wall -g -m64 -pipe -O3 -march=x86-64 -fPIC" \
        --extra-libs="-lpthread -lm -lz" \
        --enable-zlib \
        --enable-pic \
        --enable-pthreads \
        --enable-gpl \
        --enable-version3 \
        --enable-hardcoded-tables \
        --enable-avresample \
        --enable-libfreetype \
        --enable-gnutls \
        --enable-libx264 \
        --enable-libopenh264

make -j${CPU_COUNT}
make install -j${CPU_COUNT}
