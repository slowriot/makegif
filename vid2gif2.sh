#!/bin/bash
# Script to extract a portion of video to an animated gif, using ffmpeg

inputfile="$1"
starttime="$2"
length="$3"

outsize="512x512"

nameprefix="$(sed 's/ /_/g;s/\///g;s/\./_/g' <<< "$inputfile""_$starttime""_$length")"
outfile="$nameprefix".gif

if [ -z "$length" ]; then
  echo "Usage: $0 input_file start_time length" >&2
  echo "eg. $0 myvid.mp4 00:01:23 10" >&2
  exit 1
fi

palette="temp_palette.png"

filters="fps=30,scale=512:-1:flags=lanczos"

ffmpeg -v warning -ss $starttime -t $length -i $inputfile -vf "$filters,palettegen=stats_mode=full" -y $palette && \
#ffmpeg -v warning -ss $starttime -t $length -i $inputfile -vf "$filters,palettegen=stats_mode=diff" -y $palette && \
ffmpeg -v warning -ss $starttime -t $length -i $inputfile -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y "$outfile"
rm "$palette" &

outnamecomp=$(./gifcompress.sh "$outfile")
