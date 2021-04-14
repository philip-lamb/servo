@echo off
SETLOCAL EnableDelayedExpansion

SET CONFIG=release
SET VS_VERSION=2019
REM Common editions include Community and Enterprise
SET VS_EDITION=Community
SET SERVO_UNITY_PATH=..\servo-unity
SET COPY_TO_SERVOUNITY=YES
SET PYTHON=C:\Python37\python.exe

GOTO :loop
:usage
ECHO "Usage: %0 [-d|--debug] [-h|--help] [--no-copy-to-servounity] [arm64]"
ECHO "    -d|--debug Build debug config instead of release config."
ECHO "    -h|--help Display this help."
ECHO "    --no-copy-to-servounity Don't copy build to ServoUnity project."
ECHO "    arm64 Build for ARM64 target instead of x64 (i.e. x86_64)."
EXIT /B 0

:loop
IF NOT "%1"=="" (
    IF "%1"=="arm64" (
        SET TARGET=arm64
        SHIFT
    )
    IF "%1"=="--debug" (
        SET CONFIG=debug
        SHIFT
    )
    IF "%1"=="-d" (
        SET CONFIG=debug
        SHIFT
    )
    IF "%1"=="--help" (
        GOTO :usage
    )
    IF "%1"=="-h" (
        GOTO :usage
    )
    IF "%1"=="--no-copy-to-servounity" (
        SET COPY_TO_SERVOUNITY=NO
        SHIFT
    )
    GOTO :loop
)

IF "%CONFIG%"=="release" (
    SET MACH_CONFIG="--release"
) ELSE (
    SET MACH_CONFIG="--dev"
)

IF NOT "%TARGET%"=="arm64" (
    IF "%VSCMD_VER%" EQU "" (
        CALL "%programfiles(x86)%\Microsoft Visual Studio\%VS_VERSION%\%VS_EDITION%\VC\Auxiliary\Build\vcvarsall.bat" x64
    )
    %PYTHON% mach build %MACH_CONFIG% --libsimpleservo2
    IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%

    SET BUILD_DIR=target\%CONFIG%
    SET SERVO_UNITY_LIBDIR=%SERVO_UNITY_PATH%\src\ServoUnityPlugin\Windows
    SET SERVO_UNITY_BINDIR=%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\x64
) ELSE (
    %PYTHON% mach build %MACH_CONFIG% --uwp --win-arm64
    IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%

    set BUILD_DIR=target\aarch64-uwp-windows-msvc\%CONFIG%
    set SERVO_UNITY_LIBDIR=%SERVO_UNITY_PATH%\src\ServoUnityPlugin\Windows-UWP
    set SERVO_UNITY_BINDIR=%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64
)

IF "%COPY_TO_SERVOUNITY%"=="YES" (
    xcopy /f /y "!BUILD_DIR!\simpleservo2.h" "%SERVO_UNITY_PATH%\src\ServoUnityPlugin"
    xcopy /f /y "!BUILD_DIR!\simpleservo2.dll.lib" "!SERVO_UNITY_LIBDIR!"
    xcopy /f /y "!BUILD_DIR!\simpleservo2.dll" "!SERVO_UNITY_BINDIR!"

    rem Dependencies: MSVC runtimes
    xcopy /f /y "!BUILD_DIR!\msvcp140.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\vcruntime140.dll" "!SERVO_UNITY_BINDIR!"
    IF NOT "%TARGET%"=="arm64" (
        xcopy /f /y "!BUILD_DIR!\api-ms-win-crt-runtime-l1-1-0.dll" "!SERVO_UNITY_BINDIR!"
    )

    rem Dependencies: ANGLE. (UWP builds don't need this, they use a NuGet package.)
    IF NOT "%TARGET%"=="arm64" (
        xcopy /f /y "!BUILD_DIR!\libEGL.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\libGLESv2.dll" "!SERVO_UNITY_BINDIR!"
    )

    rem Dependencies: SSL
    xcopy /f /y "!BUILD_DIR!\libcrypto.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\libssl.dll" "!SERVO_UNITY_BINDIR!"

    rem Dependencies: Gstreamer core
    xcopy /f /y "!BUILD_DIR!\avcodec-58.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\avfilter-7.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\avformat-58.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\avutil-56.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\bz2.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\ffi-7.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gio-2.0-0.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\glib-2.0-0.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gmodule-2.0-0.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gobject-2.0-0.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\intl-8.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\orc-0.4-0.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\swresample-3.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\z-1.dll" "!SERVO_UNITY_BINDIR!"
    IF NOT "%TARGET%"=="arm64" (
        xcopy /f /y "!BUILD_DIR!\graphene-1.0-0.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\libcrypto-1_1-x64.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\libgmp-10.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\libgnutls-30.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\libhogweed-4.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\libjpeg-8.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\libnettle-6.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\libogg-0.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\libopus-0.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\libpng16-16.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\libssl-1_1-x64.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\libtasn1-6.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\libtheora-0.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\libtheoradec-1.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\libtheoraenc-1.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\libusrsctp-1.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\libvorbis-0.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\libvorbisenc-2.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\libwinpthread-1.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\nice-10.dll" "!SERVO_UNITY_BINDIR!"
    ) ELSE (
        xcopy /f /y "!BUILD_DIR!\avresample-4.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\postproc-55.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\swscale-5.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\x264-157.dll" "!SERVO_UNITY_BINDIR!"
    )

    rem Dependencies: Gstreamer plugins
    xcopy /f /y "!BUILD_DIR!\gstapp-1.0-0.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstapp.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstaudio-1.0-0.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstaudiobuffersplit.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstaudioconvert.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstaudiofx.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstaudioparsers.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstaudioresample.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstautodetect.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstbase-1.0-0.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstcodecparsers-1.0-0.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstcontroller-1.0-0.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstcoreelements.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstdeinterlace.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstfft-1.0-0.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstgio.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstgl-1.0-0.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstid3demux.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstid3tag.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstinterleave.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstisomp4.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstlibav.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstpbutils-1.0-0.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstplayback.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstplayer-1.0-0.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstproxy.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstreamer-1.0-0.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstriff-1.0-0.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstrtp-1.0-0.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstrtsp-1.0-0.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstsdp-1.0-0.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gsttag-1.0-0.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gsttypefindfunctions.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstvideo-1.0-0.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstvideoconvert.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstvideofilter.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstvideoparsersbad.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstvideoscale.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstvolume.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstwasapi.dll" "!SERVO_UNITY_BINDIR!"
    xcopy /f /y "!BUILD_DIR!\gstwebrtc-1.0-0.dll" "!SERVO_UNITY_BINDIR!"
    IF NOT "%TARGET%"=="arm64" (
        xcopy /f /y "!BUILD_DIR!\gstdtls.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\gstmatroska.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\gstnet-1.0-0.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\gstnice.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\gstogg.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\gstopengl.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\gstopus.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\gstrtp.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\gstrtpmanager.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\gstsctp-1.0-0.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\gsttheora.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\gstvorbis.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\gstvpx.dll" "!SERVO_UNITY_BINDIR!"
        xcopy /f /y "!BUILD_DIR!\gstwebrtc.dll" "!SERVO_UNITY_BINDIR!"
    )
)
