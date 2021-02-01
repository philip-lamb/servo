@echo off
SETLOCAL EnableDelayedExpansion

SET CONFIG=release
SET VS_VERSION=2019
REM Common editions include Community and Enterprise
SET VS_EDITION=Community
SET SERVO_UNITY_PATH=..\servo-unity

GOTO :loop
:usage
ECHO "Usage: %0 [-d|--debug] [-h|--help] [arm64]"
ECHO "    -d|--debug Build debug config instead of release config."
ECHO "    -h|--help Display this help."
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
    CALL mach build %MACH_CONFIG% --libsimpleservo2
    IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
    xcopy /f /y target\%CONFIG%\simpleservo2.h "%SERVO_UNITY_PATH%\src\ServoUnityPlugin"
    xcopy /f /y target\%CONFIG%\simpleservo2.dll.lib "%SERVO_UNITY_PATH%\src\ServoUnityPlugin\Windows"
    xcopy /f /y target\%CONFIG%\simpleservo2.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\x64"
) ELSE (
    C:\Python27\python.exe mach build %MACH_CONFIG% --uwp --win-arm64
    IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\simpleservo2.h "%SERVO_UNITY_PATH%\src\ServoUnityPlugin"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\simpleservo2.dll.lib "%SERVO_UNITY_PATH%\src\ServoUnityPlugin\Windows-UWP"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\simpleservo2.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"

    rem Dependencies: MSVC runtimes
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\msvcp140.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\vcruntime140.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"

    rem Dependencies: SSL
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\libcrypto.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\libssl.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"

    rem Dependencies: Gstreamer core
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\avcodec-58.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\avfilter-7.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\avformat-58.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\avresample-4.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\avutil-56.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\bz2.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\ffi-7.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gio-2.0-0.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\glib-2.0-0.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gmodule-2.0-0.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gobject-2.0-0.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\intl-8.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\orc-0.4-0.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\postproc-55.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\swresample-3.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\swscale-5.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\x264-157.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\z-1.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"

    rem Dependencies: Gstreamer plugins
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstapp-1.0-0.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstapp.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstaudio-1.0-0.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstaudiobuffersplit.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstaudioconvert.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstaudiofx.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstaudioparsers.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstaudioresample.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstautodetect.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstbase-1.0-0.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstcodecparsers-1.0-0.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstcontroller-1.0-0.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstcoreelements.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstdeinterlace.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstfft-1.0-0.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstgio.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstgl-1.0-0.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstid3demux.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstid3tag.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstinterleave.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstisomp4.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstlibav.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstpbutils-1.0-0.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstplayback.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstplayer-1.0-0.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstproxy.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstreamer-1.0-0.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstriff-1.0-0.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstrtp-1.0-0.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstrtsp-1.0-0.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstsdp-1.0-0.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gsttag-1.0-0.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gsttypefindfunctions.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstvideo-1.0-0.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstvideoconvert.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstvideofilter.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstvideoparsersbad.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstvideoscale.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstvolume.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstwasapi.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
    xcopy /f /y target\aarch64-uwp-windows-msvc\%CONFIG%\gstwebrtc-1.0-0.dll "%SERVO_UNITY_PATH%\src\ServoUnity\Assets\Plugins\Metro\UWP\ARM64"
)
