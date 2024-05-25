#!/usr/bin/env bash

#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

if [ -z "$1" ]; then
    echo "Usage: $0 <URL>"
    exit 1
fi

URL=$1

PATH_PARTS=$(echo "$URL" | sed 's|https://[^/]*||' | sed 's|/content||')
FILENAME=$(basename "$URL")
DIRECTORY=$(dirname "$PATH_PARTS")

mkdir -p "static/$DIRECTORY"

wget -O "static/$DIRECTORY/$FILENAME" "$URL"

echo "Download complete! File saved to static/images/$DIRECTORY/$FILENAME"