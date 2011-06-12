#!/bin/bash

for frame in `seq 0 13`
do
	cmdline=montage
	for y in `seq 0 16 183`
	do
		for x in `seq 0 16 319`
		do
			tile=`printf "%s/%03dx%03d-%03d.png" $1 $x $y $frame`
			#echo "$tile"
			if [ "$x" -eq 64 -o "$x" -eq 80 -o "$x" -eq 96 ]
			then
				if [ "$y" -eq 96 -o "$y" -eq 112 -o "$y" -eq 128 -o "$y" -eq 144 -o "$y" -eq 160 ]
				then
					tile=blank.png
				fi
			elif [ "$x" -eq 112 -a "$y" -eq 112 ]
			then
				tile=blank.png
			fi
			if [ -e "$tile" ]
			then
				cmdline="$cmdline $tile"
				#montage "$tile" -tile 20x12 -geometry 16x16+1+1 "$1-$frame.png"
			else
				cmdline="$cmdline blank.png"
			fi
		done
	done
	cmdline="$cmdline -tile 20x -geometry 16x16+0+0 $1-$frame.png"
	#echo "$cmdline"
	bash -c "$cmdline"
done
