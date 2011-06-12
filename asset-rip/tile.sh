#!/bin/bash

count=307
idiff=/home/inequation/projects/oiio-personal/dist/linux.debug/bin/idiff
iprocess=/home/inequation/projects/oiio-personal/dist/linux.debug/bin/iprocess

for i in `seq 0 $[$count - 1]`
do
	echo "image $i"
	for y in `seq 0 16 199`
	do
		for x in `seq 0 16 319`
		do
			$iprocess `printf "out%03d.png" $i` -o `printf "%03dx%03d-%03d.png" $x $y $i` --crop cut $x $[$x + 15] $y $[$y + 15] > /dev/null 2> /dev/null
			if [ $i -ge 1 ]; then
				for j in `seq 0 $[$i - 1]`
				do
					result=`$idiff \`printf "%03dx%03d-%03d.png" $x $y $j\` \`printf "%03dx%03d-%03d.png" $x $y $i\` 2> /dev/null | grep PASS`
					if [ "$result" = "PASS" ]; then
						rm `printf "%03dx%03d-%03d.png" $x $y $i`
						break
						#echo "duplicate $x $y"
					#else
						#echo "unique $x $y"
					fi
				done
			fi
		done
	done
done
