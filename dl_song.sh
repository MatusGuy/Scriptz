#!/usr/bin/env bash

yt-dlp -f bestaudio[ext=m4a] -x --verbose -o "%(channel)s - %(title)s.%(ext)s" $1
