#!/usr/bin/python3

import os, sys

filepath = sys.argv[1]
device = sys.argv[2] if len(sys.argv) > 2 else "1"

path = filepath
ext = os.path.splitext(path)[1]
is_tape = ((ext == "tap") or (ext == "tzx"))

if is_tape:
	path = "/tmp/temp.wav"
	os.system("tape2wav {} {}".format(filepath, path))

os.system("amixer -c {} sset Speaker 100%".format(device))
os.system("sox -t wav {} -S -t alsa hw:{}".format(path, device))

if is_tape:
	os.remove(path)
