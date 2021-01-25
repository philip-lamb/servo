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
)
