#!/bin/bash
set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

chmod +x scripts/*.sh 2>/dev/null || true

echo -e "${GREEN}${BOLD}"
echo "================================================================="
echo "       🚀 Kali Linux Cloud VPS is Ready (GitHub Codespaces)      "
echo "================================================================="
echo -e "${NC}"
echo -e "${CYAN}Default User:${NC} kali (Password: kali, passwordless sudo enabled)"
echo -e "${CYAN}Desktop UI (noVNC):${NC} Check the Ports tab -> Port 6080 (or open in browser)"
echo -e "${CYAN}VNC Password:${NC} kali"
echo ""
echo -e "${YELLOW}Quick Actions:${NC}"
echo -e "  - Install top security tools:   ${BOLD}bash scripts/install-tools.sh top10${NC}"
echo -e "  - Install headless metapackage: ${BOLD}bash scripts/install-tools.sh headless${NC}"
echo -e "  - Start alternative XFCE4 VNC:  ${BOLD}bash scripts/start-novnc.sh${NC}"
echo ""
echo -e "${GREEN}Happy hacking & building!${NC}"
