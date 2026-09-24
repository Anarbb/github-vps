#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

PROFILE="${1:-menu}"

update_repos() {
    echo -e "${CYAN}==> Updating Kali Linux repositories...${NC}"
    sudo apt-get update -y
}

install_top10() {
    update_repos
    echo -e "${GREEN}==> Installing Top 10 Security Tools...${NC}"
    sudo apt-get install -y --no-install-recommends \
        nmap masscan sqlmap nikto hydra john aircrack-ng wireshark-common tcpdump radare2 whois dnsutils
    echo -e "${GREEN}✅ Top 10 Security Tools installed successfully!${NC}"
}

install_headless() {
    update_repos
    echo -e "${GREEN}==> Installing Kali Linux Headless metapackage (this may take several minutes)...${NC}"
    sudo apt-get install -y kali-linux-headless
    echo -e "${GREEN}✅ Kali Linux Headless metapackage installed successfully!${NC}"
}

install_web() {
    update_repos
    echo -e "${GREEN}==> Installing Web Security & Pentesting Tools...${NC}"
    sudo apt-get install -y --no-install-recommends \
        nikto sqlmap commix gobuster dirb ffuf curl jq wafw00f
    echo -e "${GREEN}✅ Web tools installed successfully!${NC}"
}

install_passwords() {
    update_repos
    echo -e "${GREEN}==> Installing Password Recovery & Cracking Tools...${NC}"
    sudo apt-get install -y --no-install-recommends \
        hashcat john hydra medusa ncrack wordlists
    if [ -f /usr/share/wordlists/rockyou.txt.gz ] && [ ! -f /usr/share/wordlists/rockyou.txt ]; then
        echo -e "${CYAN}==> Decompressing rockyou.txt wordlist...${NC}"
        sudo gzip -d /usr/share/wordlists/rockyou.txt.gz || true
    fi
    echo -e "${GREEN}✅ Password tools and wordlists installed successfully!${NC}"
}

install_network() {
    update_repos
    echo -e "${GREEN}==> Installing Network & Wireless Tools...${NC}"
    sudo apt-get install -y --no-install-recommends \
        nmap masscan tcpdump wireshark-common dsniff ettercap-common mitmproxy whois dnsutils dnsenum fierce
    echo -e "${GREEN}✅ Network tools installed successfully!${NC}"
}

case "$PROFILE" in
    top10)
        install_top10
        ;;
    headless)
        install_headless
        ;;
    web)
        install_web
        ;;
    passwords)
        install_passwords
        ;;
    network)
        install_network
        ;;
    all)
        install_headless
        ;;
    *)
        echo -e "${BOLD}Kali Tool Installer${NC}"
        echo "Usage: bash scripts/install-tools.sh <profile>"
        echo ""
        echo "Available profiles:"
        echo -e "  ${CYAN}top10${NC}     - Top 10 pentest tools (nmap, sqlmap, hydra, john, etc.)"
        echo -e "  ${CYAN}web${NC}       - Web application testing tools (gobuster, ffuf, nikto, sqlmap)"
        echo -e "  ${CYAN}passwords${NC} - Password auditing tools and rockyou wordlist"
        echo -e "  ${CYAN}network${NC}   - Network scanning and sniffing tools"
        echo -e "  ${CYAN}headless${NC}  - Full Kali headless metapackage (~3-4GB download)"
        echo ""
        read -p "Select a profile to install [top10/web/passwords/network/headless]: " choice
        case "$choice" in
            top10|web|passwords|network|headless)
                "$0" "$choice"
                ;;
            *)
                echo -e "${RED}Invalid profile selected. Exiting.${NC}"
                exit 1
                ;;
        esac
        ;;
esac
