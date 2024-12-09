#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <list of files to make into a gif>"
fi

# 'ths of a second:
#delay=10
delay=25
tempdir="$(mktemp -d -p /dev/shm -t makegif-XXXXXX)"
mkdir -p "$tempdir"
cp "$@" "$tempdir"
pushd "$tempdir"
mogrify -monitor -limit thread $(nproc) -resize 512x512 *
convert -limit thread 60 -monitor -delay 1x"$delay" * out.gif
popd
mv "$tempdir/out.gif" ./
rm -rf "$tempdir"
