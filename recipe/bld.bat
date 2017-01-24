set FFMPEG_FN=ffmpeg-%PKG_VERSION%-win%ARCH%

curl -L -O "https://ffmpeg.zeranoe.com/builds/win%ARCH%/dev/%FFMPEG_FN%-dev.7z"

7za x %SRC_DIR%\%FFMPEG_FN%-shared.7z -o%SRC_DIR%
7za x %FFMPEG_FN%-dev.7z -o%SRC_DIR%

copy %SRC_DIR%\%FFMPEG_FN%-shared\bin %LIBRARY_BIN%
copy %SRC_DIR%\%FFMPEG_FN%-dev\include %LIBRARY_INC%
copy %SRC_DIR%\%FFMPEG_FN%-dev\lib %LIBRARY_LIB%
copy %SRC_DIR%\%FFMPEG_FN%-shared\README.txt %RECIPE_DIR%

mkdir %RECIPE_DIR%\licenses
copy %SRC_DIR%\%FFMPEG_FN%-shared\licenses %RECIPE_DIR%\licenses

exit 0