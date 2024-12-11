#!/usr/bin/bash

outputdevice=${2:-"hw:1,0"}
#sox -S -c 1 -t alsa $outputdevice $1 gain 38.0
#sox -S -t alsa $outputdevice -t wav $1
sox -t wav $1 -S -t alsa $outputdevice
