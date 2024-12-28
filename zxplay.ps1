#!/usr/bin/pwsh

param (
	[string] $Path,
	[int] $Device = 1
)

$file = $Path
$ext = Split-Path -Path $file -Extension
$tape = (($ext -eq ".tap") -or ($ext -eq ".tzx"))

if ($tape) {
	$file = "./temp.wav"

	& tape2wav $Path $file
}

& amixer -c $Device sset Speaker 100%
& sox -t wav $file -S -t alsa hw:$Device

if ($tape) {
	Remove-Item -Path $file
}
