#!/bin/bash

# unset the SUBDIR variable since it changes the behavior of make here
unset SUBDIR

#Install yasm
conda install -c conda-forge yasm=1.3.0

#Install libogg
conda install -c conda-forge libogg=1.3.2

#Install libvorbis
conda install -c conda-forge libvorbis=1.3.5

#Install libvpx
conda install -c hcc libvpx=1.5.0

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
        --enable-libx264 \
        --enable-libvorbis \
		--enable-libvpx \

make
make install
