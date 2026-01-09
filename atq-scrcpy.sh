#!/data/data/com.termux/files/usr/bin/bash

export DISPLAY=:0
termux-x11 :0 &
openbox &

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
scrcpy "${scrcpy_flags[@]}"
