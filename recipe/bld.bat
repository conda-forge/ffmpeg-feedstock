set FFMPEG_FN=ffmpeg-%PKG_VERSION%-win%ARCH%

curl -L -O "https://ffmpeg.zeranoe.com/builds/win%ARCH%/dev/%FFMPEG_FN%-dev.7z"

7za x %SRC_DIR%\%FFMPEG_FN%-shared.7z -o%SRC_DIR%
7za x %FFMPEG_FN%-dev.7z -o%SRC_DIR%

robocopy %SRC_DIR%\%FFMPEG_FN%-shared\bin\ %LIBRARY_BIN%\ *.* /E
if %ERRORLEVEL% GEQ 8 exit 1

robocopy %SRC_DIR%\%FFMPEG_FN%-dev\include\ %LIBRARY_INC%\ *.* /E
if %ERRORLEVEL% GEQ 8 exit 1

robocopy %SRC_DIR%\%FFMPEG_FN%-dev\lib\ %LIBRARY_LIB%\ *.* /E
if %ERRORLEVEL% GEQ 8 exit 1

copy %SRC_DIR%\%FFMPEG_FN%-shared\README.txt %RECIPE_DIR%

mkdir %RECIPE_DIR%\licenses
copy %SRC_DIR%\%FFMPEG_FN%-shared\licenses %RECIPE_DIR%\licenses

exit 0
