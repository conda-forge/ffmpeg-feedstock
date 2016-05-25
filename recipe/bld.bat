set LIBRARY_PREFIX=%LIBRARY_PREFIX:\=/%
set MSYSTEM=MINGW%ARCH%
set MSYS2_PATH_TYPE=inherit
set CHERE_INVOKING=1
set MSYS2_ARG_CONV_EXCL
:: Set PATH to include msys2's binaries
set "PATH=%PATH%;%LIBRARY_PREFIX%\usr\bin;%LIBRARY_PREFIX%\mingw-w64\bin"

if "%ARCH%" == "32" (set "FFMPEG_ARCH=i386")
if "%ARCH%" == "64" (set "FFMPEG_ARCH=x86_64")

bash -x ./configure --disable-asm --disable-yasm --arch=%FFMPEG_ARCH% --disable-ffserver ^
                    --disable-avdevice --disable-swscale --disable-doc ^
                    --disable-ffplay --enable-ffprobe --enable-ffmpeg ^
                    --enable-shared --disable-static --disable-bzlib ^
                    --disable-libopenjpeg --disable-iconv --disable-zlib ^
                    --toolchain=msvc --prefix=%LIBRARY_PREFIX%
make
make install
