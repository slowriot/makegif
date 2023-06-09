#!/bin/bash

#size_x=512
#size_y=512
size_x=1280
size_y=720
if [ -z "$1" ]; then
  duration=5
else
  duration="$1"
fi
outfile="out.gif"

screensize=$(xwininfo -root | awk '/-geo/{print $2}')
screensize_x=$(cut -d 'x' -f1 <<< "$screensize")
screensize_y=$(cut -d '+' -f1 <<< "$screensize" | cut -d 'x' -f 2)

byzanz-record "$outfile" -x $(((screensize_x / 2) - (size_x / 2))) -y $(((screensize_y / 2) - (size_y / 2))) -w $size_x -h $size_y -d $duration
ls -alh "$outfile"
