mach build -d --libsimpleservo2
copy target\debug\simpleservo2.h ..\servo-unity\src\ServoUnityPlugin
copy target\debug\simpleservo2.dll.lib ..\servo-unity\src\ServoUnityPlugin\Windows
copy target\debug\simpleservo2.dll ..\servo-unity\src\ServoUnity\Assets\Plugins\x64
