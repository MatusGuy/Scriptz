#!/usr/bin/env bash

yt-dlp -f bestaudio[ext=m4a] -x --verbose -o "%(artist)s - %(album)s/%(playlist_index)s - %(track)s.%(ext)s" $1
