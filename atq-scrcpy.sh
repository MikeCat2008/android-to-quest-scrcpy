#!/data/data/com.termux/files/usr/bin/bash
# ANDROID TO QUEST SCRCPY

# --- ICONS ---
# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color (Reset)

# State Icons
OK="[  ${GREEN}OK${NC}  ]"
INFO="[ ${BLUE}INFO${NC} ]"
WAIT="[ ${YELLOW}WAIT${NC} ]"
EMPTY="        "

# --- ENVIROMENT ---
export DISPLAY=:0

# Hidden temporaly file to verify if Openbox has initialiced
tmp_ready_file="$TMPDIR/.ilovefurries-uwu" # nobody's gonna know :3 - MikeCat2008
rm -f $tmp_ready_file

# --- CLEANUP FUNCION ---
cleanup(){
    echo -e "${INFO} Cleaning up ..."
    rm -f $tmp_ready_file

    echo -e "${INFO} Stopping backround processes"
    kill $(jobs -p) 2>/dev/null

    echo -e "${OK} Cleanup complete. Bye! :3"
}

# Trap signal EXIT to ensure cleanup() allways get executed
trap cleanup EXIT

# --- TERMUX-X11 WITH OPENBOX ---
echo -e "${INFO} Starting Termux-X11 with Openbox..."
# Launch Termux-X11 
termux-x11 :0 -xstartup "openbox --startup 'touch $tmp_ready_file'" &

# Wait loop until Openbox initialices
echo -e "${INFO} Waiting for Openbox..."
until [ -f $tmp_ready_file ]; do
    sleep 0.1
done
echo -e "${OK} Openbox is ready"

# --- SCRCPY ---
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
echo -e "${INFO} Starting scrcpy...\n${EMPTY} End scrcpy with SIGINT (Ctrl+C)"
scrcpy "${scrcpy_flags[@]}"

echo -e "${INFO} scrcpy process has ended"
