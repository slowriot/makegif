#!/bin/bash
# Script to extract a portion of video to a pile of images

inputfile="$1"
starttime="$2"
length="$3"
tempdir="$4"

framerate=30

outname=""

if [ -z "$length" ]; then
  echo "Usage: $0 input_file start_time length [directory]" >&2
  echo "eg. $0 myvid.mp4 00:01:23 10" >&2
  exit 1
fi

if [ -z "$tempdir" ]; then
  tempdir="./"
fi

pushd "$tempdir" >/dev/null
echo "Building image library in $tempdir of $length seconds from $starttime..."

avconv -i "$inputfile" -r "$framerate" -ss "$starttime" -t "$length" -f image2 %04d.png

echo "Finished extracting images from video into $tempdir."
popd >/dev/null
