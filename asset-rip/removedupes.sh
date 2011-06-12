#!/bin/bash

count=307
idiff=/home/inequation/projects/oiio-personal/dist/linux.debug/bin/idiff

for i in `seq 0 $[$count - 1]`
do
	a=$[$i + 1]
	for j in `seq $a $count`
	do
		result=`$idiff \`printf "out%03d.png out%03d.png" $i $j\` | grep PASS`
		if [ "$result" = "PASS" ]; then
			rm `printf "out%03d.png" $j`
		fi
	done
done
