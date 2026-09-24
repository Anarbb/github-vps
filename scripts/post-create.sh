#!/bin/bash
set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

chmod +x scripts/*.sh 2>/dev/null || true

# Ensure XFCE is configured as the active VNC session
mkdir -p "$HOME/.vnc"
cat << 'EOF' > "$HOME/.vnc/xstartup"
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
[ -r "$HOME/.Xresources" ] && xrdb "$HOME/.Xresources"
exec dbus-launch --exit-with-session startxfce4
EOF
chmod +x "$HOME/.vnc/xstartup"

echo -e "${GREEN}${BOLD}"
echo "================================================================="
echo "       🐉 Kali Linux XFCE Cloud VPS (GitHub Codespaces)         "
echo "================================================================="
echo -e "${NC}"
echo -e "${CYAN}Desktop Environment:${NC} Official Kali Linux XFCE with Kali Dark Theme & Menu"
echo -e "${CYAN}Default User:${NC} kali (Password: kali, passwordless sudo enabled)"
echo -e "${CYAN}Web Desktop (noVNC):${NC} Check Ports tab -> Port 6080"
echo -e "${CYAN}Resolution:${NC} 1920x1080 (24-bit True Color)"
echo -e "${CYAN}VNC Password:${NC} kali"
echo ""
echo -e "${YELLOW}Quick Actions:${NC}"
echo -e "  - Install top security tools:   ${BOLD}bash scripts/install-tools.sh top10${NC}"
echo -e "  - Install headless metapackage: ${BOLD}bash scripts/install-tools.sh headless${NC}"
echo -e "  - Restart/Switch XFCE Desktop:  ${BOLD}bash scripts/start-novnc.sh${NC}"
echo ""
echo -e "${GREEN}Happy hacking & building!${NC}"
