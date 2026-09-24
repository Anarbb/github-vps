#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

error_exit() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

echo -e "${GREEN}Starting setup of VNC and noVNC (XFCE4 Desktop)...${NC}"

# Update and install necessary packages
echo -e "${YELLOW}1. Updating system and installing required desktop packages...${NC}"
sudo apt update -y
sudo apt install -y --no-install-recommends \
    xfce4 xfce4-goodies novnc websockify tightvncserver dbus-x11 x11-xserver-utils || error_exit "Failed to install packages."

# Set VNC password non-interactively if not already configured
echo -e "${YELLOW}2. Configuring VNC password...${NC}"
mkdir -p "$HOME/.vnc"
VNC_PWD="${VNC_PASSWORD:-kali}"
echo "$VNC_PWD" | vncpasswd -f > "$HOME/.vnc/passwd"
chmod 600 "$HOME/.vnc/passwd"

# Generate SSL certificate for noVNC
echo -e "${YELLOW}3. Generating SSL certificate for noVNC...${NC}"
if [ ! -f "$HOME/.vnc/novnc.pem" ]; then
    openssl req -x509 -nodes -newkey rsa:3072 \
        -keyout "$HOME/.vnc/novnc.pem" \
        -out "$HOME/.vnc/novnc.pem" \
        -days 3650 \
        -subj "/C=US/ST=Cloud/L=Codespaces/O=VPS/OU=Security/CN=localhost" 2>/dev/null || error_exit "Failed to generate SSL certificate."
fi

# Configure xstartup
echo -e "${YELLOW}4. Configuring xstartup for XFCE4...${NC}"
if [ -f "$HOME/.vnc/xstartup" ]; then
    cp "$HOME/.vnc/xstartup" "$HOME/.vnc/xstartup.bak"
fi

cat <<'EOL' > "$HOME/.vnc/xstartup"
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey
startxfce4 &
EOL
chmod +x "$HOME/.vnc/xstartup"

echo -e "${GREEN}✅ Successfully configured! To start your desktop session, run:${NC}"
echo -e "   ${CYAN}bash scripts/start-novnc.sh${NC}"
