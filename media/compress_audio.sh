#!/bin/sh -

# Intended usage: this shell script is meant to take the first argument (being a path to a directory of music files)
# and copy a compressed version of them to the path from which the script is ran

find "$1" -type f \( -name "*.aiff" -o -name "*.flac" \) -exec sh -c '
    basename=$(basename "$1")
    removed_ext="${basename%.*}"
    echo "$removed_ext".mp3

    # NOTE: may not have 12 threads on system, adjust appropriately
    ffmpeg -i "$1" -threads 12 -vn -ac 2 -b:a 320k "$removed_ext".mp3

' find-sh {} \;