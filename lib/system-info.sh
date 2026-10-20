#!/usr/bin/env bash

# Shared Linux system information collection functions.

declare -gA SYSTEM_INFO=()

collect_system_info() {
    local hostname_value
    local timezone_name
    local timezone_offset
    local username
    local os_name
    local date_value
    local uptime_value
    local uptime_seconds
    local ip_cidr
    local default_gateway
    local memory_values="N/A N/A N/A"
    local disk_values="N/A N/A N/A"
    local ram_total=""
    local ram_used=""
    local ram_available=""
    local root_total=""
    local root_used=""
    local root_free=""

    SYSTEM_INFO=()

    hostname_value="$(hostname 2>/dev/null || true)"
    username="$(id -un 2>/dev/null || true)"
    date_value="$(date '+%Y-%m-%d %H:%M:%S %Z' 2>/dev/null || true)"
    os_name="$(
        awk -F= '
            $1 == "PRETTY_NAME" {
                sub(/^[^=]*=/, "")
                gsub(/^"/, "")
                gsub(/"$/, "")
                print
                exit
            }
        ' /etc/os-release 2>/dev/null || true
    )"

    timezone_name=""
    if [[ -r /etc/timezone ]]; then
        timezone_name="$(< /etc/timezone)"
    fi
    if [[ -z "$timezone_name" ]]; then
        timezone_name="$(date '+%Z' 2>/dev/null || true)"
    fi

    timezone_offset="$(date '+UTC%:z' 2>/dev/null || true)"
    if [[ -n "$timezone_offset" ]]; then
        timezone_name="${timezone_name} ${timezone_offset}"
    fi

    uptime_value="$(uptime -p 2>/dev/null || true)"
    uptime_seconds="$(
        awk 'NR == 1 { printf "%d", $1 }' /proc/uptime 2>/dev/null || true
    )"

    ip_cidr="N/A"
    default_gateway="N/A"

    if command -v ip >/dev/null 2>&1; then
        ip_cidr="$(
            ip -o -4 addr show scope global 2>/dev/null |
                awk 'NR == 1 { print $4 }'
        )"
        default_gateway="$(
            ip -4 route show default 2>/dev/null |
                awk 'NR == 1 { print $3 }'
        )"
    fi

    ip_cidr="${ip_cidr:-N/A}"
    default_gateway="${default_gateway:-N/A}"

    if command -v free >/dev/null 2>&1; then
        memory_values="$(
            free -b 2>/dev/null |
                awk '$1 == "Mem:" {
                    printf "%.2f %.2f %.2f",
                        $2 / 1073741824,
                        $3 / 1073741824,
                        $7 / 1073741824
                }'
        )"
        memory_values="${memory_values:-N/A N/A N/A}"
    fi

    read -r ram_total ram_used ram_available <<< "$memory_values" || true

    if command -v df >/dev/null 2>&1; then
        disk_values="$(
            df -P -B1 / 2>/dev/null |
                awk 'NR == 2 {
                    printf "%.2f %.2f %.2f",
                        $2 / 1073741824,
                        $3 / 1073741824,
                        $4 / 1073741824
                }'
        )"
        disk_values="${disk_values:-N/A N/A N/A}"
    fi

    read -r root_total root_used root_free <<< "$disk_values" || true

    SYSTEM_INFO[HOSTNAME]="${hostname_value:-N/A}"
    SYSTEM_INFO[TIMEZONE]="${timezone_name:-N/A}"
    SYSTEM_INFO[USER]="${username:-N/A}"
    SYSTEM_INFO[OS]="${os_name:-N/A}"
    SYSTEM_INFO[DATE]="${date_value:-N/A}"
    SYSTEM_INFO[UPTIME]="${uptime_value:-N/A}"
    SYSTEM_INFO[UPTIME_SEC]="${uptime_seconds:-N/A}"
    SYSTEM_INFO[IP_CIDR]="$ip_cidr"
    SYSTEM_INFO[DEFAULT_GATEWAY]="$default_gateway"

    SYSTEM_INFO[RAM_TOTAL_GIB]="${ram_total:-N/A}"
    SYSTEM_INFO[RAM_USED_GIB]="${ram_used:-N/A}"
    SYSTEM_INFO[RAM_AVAILABLE_GIB]="${ram_available:-N/A}"

    SYSTEM_INFO[ROOT_TOTAL_GIB]="${root_total:-N/A}"
    SYSTEM_INFO[ROOT_USED_GIB]="${root_used:-N/A}"
    SYSTEM_INFO[ROOT_AVAILABLE_GIB]="${root_free:-N/A}"
}
