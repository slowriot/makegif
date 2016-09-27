#!/bin/bash
# Script to make a copy of a a gif shrunk with lossy compression

inputfile="$1"

if [ -z "$inputfile" ]; then
  echo "Usage: $0 input_file" >&2
  exit 1
fi
outfile="$(basename $inputfile .gif)"_comp.gif
quality=80

gifsicle -O3 --lossy=$quality --colors=256 -o "$outfile" "$inputfile" && \
echo "$outfile"
#echo "$inputfile re-compressed at quality $quality% to $outfile"
