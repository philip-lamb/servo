#! /bin/bash

# Get our location.
OURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# -e = exit on errors
set -e

# -x = debug
set -x

./mach build -d --libsimpleservo2

cp -pf target/debug/simpleservo2.h ../servo-unity/src/ServoUnityPlugin
cp -pf target/debug/libsimpleservo2.dylib ../servo-unity/src/ServoUnity/Assets/Plugins

# Copy plugins
(cd target/debug &&
cp -pf libgstapp.dylib \
libgstaudiobuffersplit.dylib \
libgstaudioconvert.dylib \
libgstaudiofx.dylib \
libgstaudioparsers.dylib \
libgstaudioresample.dylib \
libgstautodetect.dylib \
libgstcoreelements.dylib \
libgstdeinterlace.dylib \
libgstdtls.dylib \
libgstgio.dylib \
libgstid3tag.dylib \
libgstid3demux.dylib \
libgstinterleave.dylib \
libgstisomp4.dylib \
libgstlibav.dylib \
libgstmatroska.dylib \
libgstogg.dylib \
libgstopengl.dylib \
libgstopus.dylib \
libgstplayback.dylib \
libgstproxy.dylib \
libgstrtp.dylib \
libgstrtpmanager.dylib \
libgsttheora.dylib \
libgsttypefindfunctions.dylib \
libgstvideoconvert.dylib \
libgstvideofilter.dylib \
libgstvideoparsersbad.dylib \
libgstvideoscale.dylib \
libgstvorbis.dylib \
libgstvolume.dylib \
libgstvpx.dylib \
libgstwebrtc.dylib \
libgstosxaudio.dylib \
libgstosxvideo.dylib \
libgstnice.dylib \
../../../servo-unity/src/ServoUnity/Assets/Plugins)

# Also copy to Unity app folder to allow to run in Editor.
(cd target/debug &&
cp -pf libgstapp.dylib \
libgstaudiobuffersplit.dylib \
libgstaudioconvert.dylib \
libgstaudiofx.dylib \
libgstaudioparsers.dylib \
libgstaudioresample.dylib \
libgstautodetect.dylib \
libgstcoreelements.dylib \
libgstdeinterlace.dylib \
libgstdtls.dylib \
libgstgio.dylib \
libgstid3tag.dylib \
libgstid3demux.dylib \
libgstinterleave.dylib \
libgstisomp4.dylib \
libgstlibav.dylib \
libgstmatroska.dylib \
libgstogg.dylib \
libgstopengl.dylib \
libgstopus.dylib \
libgstplayback.dylib \
libgstproxy.dylib \
libgstrtp.dylib \
libgstrtpmanager.dylib \
libgsttheora.dylib \
libgsttypefindfunctions.dylib \
libgstvideoconvert.dylib \
libgstvideofilter.dylib \
libgstvideoparsersbad.dylib \
libgstvideoscale.dylib \
libgstvorbis.dylib \
libgstvolume.dylib \
libgstvpx.dylib \
libgstwebrtc.dylib \
libgstosxaudio.dylib \
libgstosxvideo.dylib \
libgstnice.dylib \
/Applications/Unity/Hub/Editor/2019.3.13f1/Unity.app/Contents/MacOS)