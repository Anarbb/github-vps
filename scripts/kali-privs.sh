#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Look for running Kali container
kali_id=$(docker ps -q --filter "ancestor=kalilinux/kali-rolling" | head -n 1)

if [ -z "$kali_id" ]; then
    # Look for stopped container
    kali_id=$(docker ps -a -q --filter "ancestor=kalilinux/kali-rolling" | head -n 1)
fi

if [ -z "$kali_id" ]; then
    echo -e "${YELLOW}No existing Kali container found. Starting a new privileged container...${NC}"
    docker run --privileged -it --name kali-vps kalilinux/kali-rolling /bin/bash
    exit $?
fi

echo -e "${CYAN}Found Kali container: ${kali_id}${NC}"
docker start "$kali_id" >/dev/null 2>&1

echo -e "${GREEN}Connecting to Kali session...${NC}"
docker exec -it "$kali_id" /bin/bash
