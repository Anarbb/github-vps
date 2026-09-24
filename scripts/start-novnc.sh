#!/bin/bash
set -e

NC="\033[0m"
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"

WEB_DIR="/usr/share/novnc"
CERT_FILE="$HOME/.vnc/novnc.pem"
LOCAL_PORT="5901"
LISTEN_PORT="6080"
RESOLUTION="${RESOLUTION:-1920x1080}"

# Clean up any stale locks or processes on display :1
vncserver -kill :1 2>/dev/null || true
pkill -f "websockify.*$LISTEN_PORT" 2>/dev/null || true

# Verify VNC password exists
if [ ! -f "$HOME/.vnc/passwd" ]; then
    echo -e "${YELLOW}VNC password file not found. Running setup...${NC}"
    bash "$(dirname "$0")/setup-novnc.sh"
fi

# Start VNC Server
echo -e "${YELLOW}Starting VNC Server (display :1, resolution ${RESOLUTION})...${NC}"
vncserver :1 -geometry "$RESOLUTION" -depth 24

# Start websockify / noVNC
echo -e "${YELLOW}Starting noVNC web proxy on port ${LISTEN_PORT}...${NC}"
if [ -f "$CERT_FILE" ]; then
    websockify -D --web="$WEB_DIR" --cert="$CERT_FILE" "$LISTEN_PORT" "localhost:$LOCAL_PORT"
else
    websockify -D --web="$WEB_DIR" "$LISTEN_PORT" "localhost:$LOCAL_PORT"
fi

echo -e "${GREEN}====================================================${NC}"
echo -e "${GREEN}✅ noVNC Web Desktop is active!${NC}"
echo -e "   Browser Access: ${CYAN}http://localhost:${LISTEN_PORT}/vnc.html${NC}"
echo -e "   Direct VNC:     ${CYAN}localhost:${LOCAL_PORT}${NC}"
echo -e "   Default Password: ${WHITE}kali${NC}"
echo -e "${GREEN}====================================================${NC}"
