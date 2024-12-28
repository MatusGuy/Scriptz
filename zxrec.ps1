#!/usr/bin/pwsh

param (
	[string] $Path,
	[int] $Device = 1
)

$file = $Path
$ext = Split-Path -Path $file -Extension
$tape = (($ext -eq ".tap") -or ($ext -eq ".tzx"))

if ($tape) {
	$file = "./temprec.wav"
}

& amixer -c $Device sset Mic 75%
& sox -S -b 16 -c 1 -r 44100 -t alsa hw:$Device $file

if ($tape) {
	& audio2tape $file $Path
	Remove-Item -Path $file
}
