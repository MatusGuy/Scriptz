#!/usr/bin/bash


SCRIPT_DIR=$(dirname "$(realpath "$0")")
outputdevice=${2:-1}

tape2wav $1 temp.wav

$SCRIPT_DIR/zxplay.sh temp.wav $2

rm temp.wav
