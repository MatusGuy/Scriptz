#!/usr/bin/bash

outputdevice=${2:-"hw:1,0"}

tape2wav $1 temp.wav

sox -t wav temp.wav -S -t alsa $outputdevice

rm temp.wav
