set FFMPEG_FN=ffmpeg-2.8.6-win%ARCH%-shared

7za x %SRC_DIR%\%FFMPEG_FN%.7z -o%SRC_DIR%
mkdir %SCRIPTS%
copy %SRC_DIR%\%FFMPEG_FN%\bin %SCRIPTS%
copy %SRC_DIR%\%FFMPEG_FN%\licenses %SCRIPTS%
copy %SRC_DIR%\%FFMPEG_FN%\README.txt %SCRIPTS%
copy %SRC_DIR%\%FFMPEG_FN%\ff-prompt.bat %SCRIPTS%