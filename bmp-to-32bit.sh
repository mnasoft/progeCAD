#!/bin/bash

for f in `ls *.bmp`
do
    magick "$f" -alpha on -define bmp:format=bmp4 "32bit_$f"
done
