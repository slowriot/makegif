#!/bin/bash

dir="$1"
#checkdither=true
checkdither=false
voice=Daniel
#voice=Moira
#voice=Pipe
#voice=Trinoids

if [ -z "$dir" ]; then
  echo "Usage: $0 directory-of-images" >&2
  exit 1
fi

threads=$(grep -c "^processor" /proc/cpuinfo)

function announce {
  echo "$1"
  if [ ! -z "$(which say)" ]; then
    say -v$voice "$1" &
  fi
}

announce "Animating $dir with $threads threads..."
nameprefix="$(sed 's/ /_/g;s/\///g' <<< "$dir")"
outname="$nameprefix"_680.gif
outnamecomp="$nameprefix"_680_comp.gif

if $checkdither; then
  # determine optimal dithering level
  filelist="$(ls "$dir"/*.png)"
  filecount="$(wc -l <<< "$filelist")"
  midfile="$(head -n $((filecount / 2)) <<< "$filelist" | tail -1)"
  announce "Determining initial dither level based on $midfile"
  ditherlevel=1
  colours=0
  maxditherlevel=13
  while [ "$colours" -lt 256 ] && [ "$ditherlevel" -lt "$maxditherlevel" ]; do
    ((ditherlevel++))
    oldcolours=$colours
    colours=$(convert -limit thread $threads "$midfile" -ordered-dither o8x8,$ditherlevel -append -format %k info:)
    echo "Dither level $ditherlevel = $colours colours"
  done
  ((ditherlevel--))
  colours=$oldcolours
  announce "Preliminary optimal dither level seems to be $ditherlevel for $colours colours, confirming over entire image set..."
  colours=$(convert -limit thread $threads "$dir"/*.png -ordered-dither o8x8,$ditherlevel -append -format %k info:)
  while [ "$colours" -ge 256 ]; do
    ((ditherlevel--))
    echo "No, that's too high ($colours colours), retrying with dither level $ditherlevel..."
    colours=$(convert -limit thread $threads "$dir"/*.png -ordered-dither o8x8,$ditherlevel -append -format %k info:)
  done
  announce "Optimal dither level is $ditherlevel for $colours colours."
else
  ditherlevel=11
fi
	
#options="-verbose -monitor"
#time convert $options -loop 0 -delay 1x30 -dispose none -type Palette +map "$dir"/*.png "$outname"
time convert \
  -limit thread $threads \
  -monitor \
  -loop 0 \
  -delay 1x30 \
  -dispose previous \
  -type Palette \
  -layers OptimizePlus \
  -layers OptimizeTransparency \
  +remap \
  "$dir"/*.png "$outname"

#  -dispose none \
##  -layers OptimizeTransparency \
##  -layers OptimizeFrame \
#  -layers Optimize \
#  -ordered-dither o8x8,$ditherlevel \
#  +map \
#  +remap \

if [ "$?" != 0 ]; then
  announce "There was a problem animating $dir."
  echo "Exited with an error."
  exit 1
fi

size=$(du -sh "$outname" | cut -f 1 | sed 's/K/ kilobytes/;s/M/ megabytes/;s/G/ gigabytes/;')
announce "Animated GIF of $dir rendered, size $size, optimising..."
echo "Rendered: $outname $size, optimising..."

gifsicle -O3 --lossy=80 --colors=256 -o "$outnamecomp" "$outname"

sizecomp=$(du -sh "$outnamecomp" | cut -f 1 | sed 's/K/ kilobytes/;s/M/ megabytes/;s/G/ gigabytes/;')
announce "Animated GIF of $dir ready, size $sizecomp."
