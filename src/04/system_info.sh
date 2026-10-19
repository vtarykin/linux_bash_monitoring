#!/bin/bash

get_system_info() {
    HOSTNAME=$(hostname)
    USER=$(whoami)
    DATE=$(date +"%d %b %Y %H:%M:%S")
   
    read -r TIMEZONE <<< "$(cat /etc/timezone) UTC$(date +"%:::z" | sed 's/^\+0\+/\+/g')"
    
    OS=$(grep -E '^PRETTY_NAME=' /etc/os-release | cut -d '"' -f 2)    
    #OS=$(head -n 1 /etc/os-release | cut -d '"' -f 2)
    
    read UPTIME_SEC < <(cat /proc/uptime | awk '{printf "%d", $1}')
    UPTIME=$(uptime -p)
    
    IP=$(hostname -I | cut -d' ' -f1)
    MASK=$(ip addr show | grep -Po 'inet \K[\d.]+/\d+' | head -n1)
    GATEWAY=$(ip route | awk '/default/ {print $3}')
    
    read -r RAM_TOTAL RAM_USED RAM_FREE < <(free -m | awk '/Mem:/ {printf "%.3f %.3f %.3f", $2/1024, $3/1024, $4/1024}')
    RAM_TOTAL="${RAM_TOTAL} GB"
    RAM_USED="${RAM_USED} GB"
    RAM_FREE="${RAM_FREE} GB"
    
    read -r SPACE_ROOT SPACE_ROOT_USED SPACE_ROOT_FREE < <(df / | awk 'NR==2 {printf "%.2f %.2f %.2f", $2/1024, $3/1024, $4/1024}')
    SPACE_ROOT="${SPACE_ROOT} MB"
    SPACE_ROOT_USED="${SPACE_ROOT_USED} MB"
    SPACE_ROOT_FREE="${SPACE_ROOT_FREE} MB"
}
