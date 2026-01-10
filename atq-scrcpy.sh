#!/data/data/com.termux/files/usr/bin/bash
# ANDROID TO QUEST SCRCPY


# ENVIROMENT
export DISPLAY=:0

tmp_ready_file="$TMPDIR/.ilovefurries-uwu" # nobody's gonna know :3 - MikeCat2008
rm -f $tmp_ready_file


# CLEANUP FUNCION ON EXIT
cleanup(){
    echo -e "\n[] Cleaning up ..."
    rm -f $tmp_ready_file

    echo "[] Stopping backround processes"
    kill $(jobs -p) 2>/dev/null
}

trap cleanup EXIT


# TERMUX-X11 WITH OPENBOX
echo "[] Starting Termux-X11 with Openbox..."
termux-x11 :0 -xstartup "openbox --startup 'touch $tmp_ready_file'" &

echo "[] Waiting for Openbox..."
until [ -f $tmp_ready_file ]; do
    sleep 0.1
done
echo "[] Openbox is ready"


# SCRCPY
scrcpy_flags=(
    --fullscreen            # Start in fullscreen mode
    --video-codec=h264      # Use H.264 for wide compatibility and low latency
    --max-fps=30            # Cap framerate to 30 FPS to save bandwidth/CPU
    --max-size=720          # Limit resolution to 720p (optimal quality/performance)
    --video-bit-rate=4M     # Set 4 Mbps bitrate for a stable, lag-free stream
    --no-audio              # Disable audio to reduce overhead (not supported on Termux)
    --render-driver=opengl  # Force OpenGL for hardware-accelerated rendering
)

# Launch scrcpy with the defined flags
echo "[] Starting scrcpy..."
scrcpy "${scrcpy_flags[@]}"

echo "[] scrcpy process has ended"
