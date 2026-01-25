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
ERROR="[ ${RED}ERR.${NC} ]"
EMPTY="        "

# --- ENVIRONMENT ---
export DISPLAY=:0

# Hidden temporaly file to verify if Openbox has initialized
tmp_ready_file="$TMPDIR/.ilovefurries-uwu" # nobody's gonna know :3 - MikeCat2008

# --- FUNCTIONS ---

cleanup(){
    echo -e "${INFO} Cleaning up ..."
    rm -f "$tmp_ready_file"

    echo -e "${INFO} Stopping background processes"
    kill $(jobs -p) 2>/dev/null

    echo -e "${OK} Cleanup complete. Bye! :3"
}

# Trap signal EXIT to ensure cleanup() always get executed
trap cleanup EXIT

check_dependencies() {
    local dependencies=("android-tools" "scrcpy" "termux-x11-nightly" "openbox")
    local missing_deps=()
    local uninstalled_deps=()

    echo -e "${INFO} Verifying environment..."

    # Check X11 Repo
    if [ ! -f "$PREFIX/etc/apt/sources.list.d/x11.list" ]; then
        echo -e "${ERROR} X11 Repository not detected."
        while true; do
            echo -ne "${YELLOW}[?] Do you want to enable X11 repo? (y/n): ${NC}"
            read x11_choice
            case $x11_choice in
                [Yy]* )
                    echo -e "${WAIT} Enabling X11 repository..."
                    pkg update && pkg install x11-repo -y
                    break;;
                [Nn]* )
                    echo -e "${ERROR} X11 is required for this project. Exiting..."
                    exit 1;;
                * ) echo -e "${YELLOW}Please answer yes (y) or no (n).${NC}";;
            esac
        done

        # Re-check repository after installation attempt
        if [ ! -f "$PREFIX/etc/apt/sources.list.d/x11.list" ]; then
            echo -e "${ERROR} The X11 could not be installed. Exiting..."
            echo -e "${EMPTY} Please check your network connection or main repository access."
            echo -e "${EMPTY} This may be caused by network restrictions or blocked repositories."
            exit 1
        fi
    else
        echo -e "${OK} X11 Repository enabled."
    fi

    # Check Packages
    for pkg in "${dependencies[@]}"; do
        if ! dpkg -s "$pkg" &>/dev/null; then
            echo -e "${INFO} Package ${pkg} is ${RED}missing${NC}."
            missing_deps+=("$pkg")
        else
            echo -e "${OK} Package ${pkg} is ${GREEN}installed${NC}."
        fi
    done

    # Install missing packages
    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo -e "${INFO} Missing packages: ${YELLOW}${missing_deps[*]}${NC}"
        while true; do
            echo -ne "${YELLOW}[?] Install them now? (y/n): ${NC}"
            read pkg_choice
            case $pkg_choice in
                [Yy]* )
                    echo -e "${WAIT} Updating and installing..."
                    pkg update && pkg install "${missing_deps[@]}" -y
                    break;;
                [Nn]* )
                    echo -e "${ERROR} Missing critical dependencies. Aborting."
                    exit 1;;
                * ) echo -e "${YELLOW}Please answer yes (y) or no (n).${NC}";;
            esac
        done

        # Re-check packages after installation attempt
        for pkg in "${missing_deps[@]}"; do
            if ! dpkg -s "$pkg" &>/dev/null; then
                echo -e "${ERROR} Package ${pkg} is ${RED}still missing${NC}."
                uninstalled_deps+=("$pkg")
            else
                echo -e "${OK} Package ${pkg} has been ${GREEN}successfully installed${NC}."
            fi
        done
        if [ ${#uninstalled_deps[@]} -ne 0 ]; then
            echo -e "${ERROR} The following dependencies could not be installed:"
            echo -e "${EMPTY} ${RED}${uninstalled_deps[*]}${NC}"
            echo -e "${EMPTY} Please check your network connection or repositories access."
            echo -e "${EMPTY} This may be caused by network restrictions or blocked repositories."
            exit 1
        fi
    fi
    echo -e "${OK} All dependencies are satisfied."
}

# --- MAIN EXECUTION ---

# First, check if everything is installed
check_dependencies

# Prepare environment
rm -f "$tmp_ready_file"

# --- TERMUX-X11 WITH OPENBOX ---
echo -e "${INFO} Launching Termux-X11 App..."
# Automaticaly launching Termux-X11 App
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity

echo -e "${INFO} Starting Termux-X11 with Openbox..."
# Launch Termux-X11 Server
termux-x11 :0 -xstartup "openbox --startup 'touch $tmp_ready_file'" &

# Wait loop until Openbox initialices
echo -e "${WAIT} Waiting for Openbox..."
until [ -f "$tmp_ready_file" ]; do
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
echo -e "${INFO} Starting scrcpy...\n\n${YELLOW}End scrcpy with SIGINT (Ctrl+C)${NC}\n"
scrcpy "${scrcpy_flags[@]}"

echo -e "\n${INFO} scrcpy process has ended"
