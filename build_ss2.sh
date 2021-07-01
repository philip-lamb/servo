#! /bin/bash

# Get our location.
OURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CONFIG=release

function usage {
    echo "Usage: $(basename $0) [-|--help] [--debug] [--install-unity-editor-dependencies]"
    exit 1
}

#if [ $# -eq 0 ]; then
#    usage
#fi

# -e = exit on errors
set -e

# -x = debug
set -x

# Parse parameters
while test $# -gt 0
do
    case "$1" in
        --debug) CONFIG=debug
            ;;
        --help) usage
            ;;
        -h) usage
            ;;
        --*) echo "bad option $1"
            usage
            ;;
        *) echo "bad argument $1"
            usage
            ;;
    esac
    shift
done

if [ $CONFIG = "release" ] ; then
    MACH_CONFIG=--release
else
    MACH_CONFIG=--dev
fi

./mach build $MACH_CONFIG --libsimpleservo2

cp -pf target/$CONFIG/simpleservo2.h ../servo-unity/src/ServoUnityPlugin
cp -pf target/$CONFIG/libsimpleservo2.dylib ../servo-unity/src/ServoUnityPlugin/depends/macos/lib
install_name_tool -id "@loader_path/libsimpleservo2.dylib" ../servo-unity/src/ServoUnityPlugin/depends/macos/lib/libsimpleservo2.dylib

# Copy plugins
(cd target/$CONFIG &&
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
../../../servo-unity/src/ServoUnityPlugin/depends/macos/lib)
