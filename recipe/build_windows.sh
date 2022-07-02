set -ex
mkdir -p /tmp
touch /tmp/test.txt
export BUILD_LIBRARY_PREFIX=${CYGWIN_PREFIX}/../_build_env/Library

# I'm really not sure why these two are not added to the path
export PATH="${BUILD_LIBRARY_PREFIX}/mingw-w64/bin:${PATH}"
export PATH="${BUILD_LIBRARY_PREFIX}/bin:${PATH}"
export PATH="${CYGWIN_PREFIX}/Library/mingw-w64/bin:${PATH}"
export PATH="${CYGWIN_PREFIX}/Library/bin:${PATH}"

export CC=x86_64-w64-mingw32-gcc
export CXX=x86_64-w64-mingw32-g++
export NM=x86_64-w64-mingw32-gcc-nm
export AR=x86_64-w64-mingw32-gcc-ar

echo ${target_platform}
echo ${BUILD_PREFIX}
ls -lah ${BUILD_PREFIX}
ls -lah ${BUILD_PREFIX}/Library
nasm --help
pkg-config --help
# Check that this exists
${BUILD_PREFIX}/Library/mingw-w64/bin/pkg-config --help

# LD???
# export LD=x86_64-w64-mingw32-gcc-ld
export PKG_CONFIG=${BUILD_PREFIX}/Library/mingw-w64/bin/pkg-config

# Fail early if PATH is not setup correctly
${CC} --version
${CXX} --version
${NM} --version
${AR} --version
nasm --version
${PKG_CONFIG} --version

./configure                      \
    --prefix=${CYGWIN_PREFIX}    \
    --host-cc=${CC}              \
    --cc=${CC}                   \
    --cxx=${CXX}                 \
    --nm=${NM}                   \
    --ar=${AR}                   \
    --enable-cross-compile       \
    --cross-prefix=x86_64-w64-mingw32-gcc- \
    --target-os=mingw64          \
    --arch=x86_64                \
    --disable-doc                \
    --disable-openssl            \
    --enable-demuxer=dash        \
    --enable-gpl                 \
    --enable-hardcoded-tables    \
    --enable-pic                 \
    --enable-shared              \
    --disable-static             \
    --enable-version3            \
    --pkg-config=${PKG_CONFIG}   \
    || (cat ffbuild/config.log && exit 1)

make V=1 VERBOSE=1
make install
