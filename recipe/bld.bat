@echo ON

set FFMPEG_FN=ffmpeg-%PKG_VERSION%-win%ARCH%

rem On a version update, change the following SHA256 hashes (win32 and win64)
if %ARCH% == 32 (
    set FFMPEG_SHA256="SHA256(%FFMPEG_FN%-dev.7z)= 399cf13962a576a75b1b2850eb80d591f17767876adcb93c783bbbbd7e130e9a"
) else (
    set FFMPEG_SHA256="SHA256(%FFMPEG_FN%-dev.7z)= abebb0cb20328905b95d3bd24af3f87922278e0c8fd387306e0ff5621434c425"
)

rem Download the source and check the SHA256
curl -L -O "https://ffmpeg.zeranoe.com/builds/win%ARCH%/dev/%FFMPEG_FN%-dev.7z"
openssl dgst -sha256 -out sha256.out %FFMPEG_FN%-dev.7z
SET /p DOWNLOADED_SHA256=<sha256.out
if NOT "%DOWNLOADED_SHA256%" == %FFMPEG_SHA256% (
    exit 1
)

rem Extract the archives
7za x %SRC_DIR%\%FFMPEG_FN%-shared.7z -o%SRC_DIR%
7za x %FFMPEG_FN%-dev.7z -o%SRC_DIR%

rem Copy over the bin, include and lib dirs
robocopy %SRC_DIR%\%FFMPEG_FN%-shared\bin\ %LIBRARY_BIN%\ *.* /E
if %ERRORLEVEL% GEQ 8 exit 1

robocopy %SRC_DIR%\%FFMPEG_FN%-dev\include\ %LIBRARY_INC%\ *.* /E
if %ERRORLEVEL% GEQ 8 exit 1

robocopy %SRC_DIR%\%FFMPEG_FN%-dev\lib\ %LIBRARY_LIB%\ *.* /E
if %ERRORLEVEL% GEQ 8 exit 1

rem Add the licences to the recipe directory
copy "%SRC_DIR%\%FFMPEG_FN%-shared\README.txt" "%RECIPE_DIR%"
mkdir "%RECIPE_DIR%\licenses"
copy "%SRC_DIR%\%FFMPEG_FN%-shared\licenses" "%RECIPE_DIR%\licenses"

exit 0
