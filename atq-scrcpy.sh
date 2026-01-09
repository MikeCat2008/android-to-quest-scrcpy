#!/data/data/com.termux/files/usr/bin/bash

export DISPLAY=:0
termux-x11 :0 &
openbox &
scrcpy
