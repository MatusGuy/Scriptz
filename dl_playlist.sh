#!/usr/bin/env bash

yt-dlp -f bestaudio -x --verbose -o "%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s" $1
