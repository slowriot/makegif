#!/bin/bash

tempdir="/dev/shm/makegif"
mkdir -p "$tempdir"
cp $@ "$tempdir"
pushd
cd "$tempdir"
mogrify -monitor -limit thread $(nproc) -resize 512x512 *
convert -limit thread 60 -monitor -delay 1x10 * out.gif
popd
mv "$tempdir/out.gif" ./
rm -rf "$tempdir"
