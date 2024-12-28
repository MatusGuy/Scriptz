#!/usr/bin/bash

outputdevice=${2:-1}
amixer -c $outputdevice sset Mic 75%
sox -S -b 16 -c 1 -r 44100 -t alsa hw:$outputdevice $1
