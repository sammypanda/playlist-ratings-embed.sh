#!/bin/sh

# variables
music_dir=/mnt/storage/Music
playlist=$1
rating=$2

# check functions
playlistchecks() {
    if ! echo $playlist | grep ".m3u" > /dev/null; then
        echo "playlist must be an .m3u file"
        return 1
    fi
}

# check rating int
if [[ -z $2 ]]; then
    echo "please put rating after m3u path"
    exit
fi

# check inputs/options
if [ -f "$playlist" ]; then
    if ! playlistchecks; then exit; fi
    echo -e "playlist: $playlist\n"
    shift
else
    echo "add the m3u file as the first param (^^)"
	exit 1
fi

# main loop process
IFS=$'\n'
x=0
# DEBUG: echo $(cat "$playlist")
for line in $(cat "$playlist"); do

    if [[ "$line" =~ "$music_dir" ]]; then

        kid3-cli -c "set ratingstars $rating" "$line"

    fi
done
unset IFS

# finish notification
playlist=$(echo "$1" | cut -f  1 -d '.')
notify-send "$USER" "Ratings from '$playlist' pushed to metadata"
