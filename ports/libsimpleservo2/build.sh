#! /bin/bash

#
# Simple script to build libsimpleservo2.
#
# Copyright 2020, Mozilla.
# Author(s): Philip Lamb
#

# Get our location.
OURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function usage {
    echo "Usage: $(basename $0) [-v|--verbose] [--debug]"
    exit 1
}

# -e = exit on errors
set -e
# -x = debug
#set -x

# Parse parameters
while test $# -gt 0
do
    case "$1" in
        --debug) DEBUG=
            ;;
        --verbose) VERBOSE=1
            ;;
        -v) VERBOSE=1
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


cd ${OURDIR}/capi
CARGO_TARGET_DIR=${PWD}/../../../target;export CARGO_TARGET_DIR

cargo build ${DEBUG---release} --features "layout-2013 media-gstreamer"

echo "Build products are in ${CARGO_TARGET_DIR}/${DEBUG+debug}${DEBUG-release}/".
