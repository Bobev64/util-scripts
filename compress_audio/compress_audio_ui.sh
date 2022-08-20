#!/bin/sh -

# Intended usage: this shell script is meant to take the first argument (being a path to a directory of music files)
# and copy a compressed version of them to the path from which the script is ran

# TODO: Figure out why the below code works in executing the following block of code for both aiff and flac files
# Answers found here: https://unix.stackexchange.com/questions/15308/how-to-use-find-command-to-search-for-multiple-extensions

convert_dir () {
    find "$1" -type f \( -name "*.aiff" -o -name "*.flac" \) -exec sh -c '
        basename=$(basename "$1")
        removed_ext="${basename%.*}"
        echo "$removed_ext".mp3
    
        # NOTE: may not have 12 threads on system, adjust appropriately
        ffmpeg -i "$1" -threads 12 -vn -ac 2 -b:a 320k "$removed_ext".mp3
    
    ' find-sh {} \;
}

CONVERT_DIR=$(dialog --title "Convert a Directory to MP3" --stdout --title "Choose a Directory to Convert" --erase-on-exit --fselect "$1" 360 360)

echo "$CONVERT_DIR"
[ ! -z "$CONVERT_DIR" ] && convert_dir "$CONVERT_DIR"

# TODO: Figure out how to get full dir of directory to copy files to from above
# ffmpeg -i "$1" -vn -ac 2 -b:a 320k "$removed_ext".mp3
