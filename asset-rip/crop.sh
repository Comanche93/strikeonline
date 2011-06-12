#!/bin/bash

iprocess=/home/inequation/projects/oiio-personal/dist/linux.debug/bin/iprocess

for i in `seq 2 13`
do
	$iprocess "zrzut_ekranu-$i.png" -o "cropped-$i.png" --crop cut 161 480 156 355
done
