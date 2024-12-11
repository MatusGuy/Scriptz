#!/usr/bin/bash

outputdevice=${2:-1}
#sox -S -c 1 -t alsa $outputdevice $1 gain 38.0
#sox -S -t alsa $outputdevice -t wav $1
amixer -c $outputdevice sset Speaker 100%
sox -t wav $1 -S -t alsa hw:$outputdevice
