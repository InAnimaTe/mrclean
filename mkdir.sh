#!/bin/bash
find "$1" -maxdepth 1 -type f | grep '.mkv$\|.avi$\|.mp4$' | while read file
do
cd "$1"
dirname=$(echo "$file" | awk -F "/" '{print $(NF)}' | sed s/\.mkv//g | sed s/\.avi//g | sed s/\.mp4//g)
mkdir "$dirname"
mv "$file" "$dirname" 
echo "$file has been moved to $dirname"
done
  
