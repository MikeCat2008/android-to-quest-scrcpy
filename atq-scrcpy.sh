#!/data/data/com.termux/files/usr/bin/bash

export DISPLAY=:0
termux-x11 :0 &
openbox &
scrcpy --no-audio --video-codec=h264 --video-bit-rate=6M --max-size=800 --no-audio
