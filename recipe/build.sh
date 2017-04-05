#!/bin/bash

# unset the SUBDIR variable since it changes the behavior of make here
unset SUBDIR

git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
cd libvpx
./configure --prefix="/usr" --disable-examples
make
make install


./configure \
        --prefix="${PREFIX}" \
        --disable-doc \
        --enable-shared \
        --enable-static \
        --extra-cflags="-Wall -g -m64 -pipe -O3 -march=x86-64 -fPIC `pkg-config --cflags zlib`" \
        --extra-cxxflags=="-Wall -g -m64 -pipe -O3 -march=x86-64 -fPIC" \
        --extra-libs="`pkg-config --libs zlib`" \
        --enable-pic \
        --enable-gpl \
	--enable-libvpx \
        --enable-libx264

make
make install
