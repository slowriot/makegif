#!/bin/bash

if [ -z "$1" ]; then
  duration=5
else
  duration="$1"
fi
outfile="out.gif"

echo "Select the window to record"

window_geometry=$(xdotool selectwindow getwindowgeometry --shell)
pos_x=$(grep "^X=" <<< "$window_geometry" | cut -d '=' -f 2-)
pos_y=$(grep "^Y=" <<< "$window_geometry" | cut -d '=' -f 2-)
size_x=$(grep "^WIDTH=" <<< "$window_geometry" | cut -d '=' -f 2-)
size_y=$(grep "^HEIGHT=" <<< "$window_geometry" | cut -d '=' -f 2-)
echo "Coords: $pos_x x $pos_y, size: $size_x x $size_y"

echo -n "Recording in 3..."
sleep 1;
echo -ne "\rRecording in 2 .."
sleep 1;
echo -ne "\rRecording in 1  ."
sleep 1;
echo -e "\rRecording for $duration seconds"

#screensize=$(xwininfo -root | awk '/-geo/{print $2}')
#screensize_x=$(cut -d 'x' -f1 <<< "$screensize")
#screensize_y=$(cut -d '+' -f1 <<< "$screensize" | cut -d 'x' -f 2)

byzanz-record "$outfile" -x "$pos_x" -y "$pos_y" -w "$size_x" -h "$size_y" -d "$duration"

echo "Recording saved to $outfile"
exit
