#!/bin/bash
# Script to extract a portion of video to an animated gif

inputfile="$1"
starttime="$2"
length="$3"

outsize="512x512"

if [ -z "$length" ]; then
  echo "Usage: $0 input_file start_time length" >&2
  echo "eg. $0 myvid.mp4 00:01:23 10" >&2
  exit 1
fi

tempdir="$(mktemp -d --suffix=_makegif)"

./vidextract.sh "$inputfile" "$starttime" "$length" "$tempdir"

echo "Resizing images to $outsize..."
mogrify -format png -resize $outsize "$tempdir/"*.png

echo "Resizing images to $outsize..."
./makegif.sh "$tempdir"

rm -r "$tempdir"
