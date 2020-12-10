if "%VSCMD_VER%" EQU "" (
    call "%programfiles(x86)%\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
)
call mach build -d --libsimpleservo2

xcopy /f /y target\debug\simpleservo2.h ..\servo-unity\src\ServoUnityPlugin
xcopy /f /y target\debug\simpleservo2.dll.lib ..\servo-unity\src\ServoUnityPlugin\Windows
xcopy /f /y target\debug\simpleservo2.dll ..\servo-unity\src\ServoUnity\Assets\Plugins\x64
