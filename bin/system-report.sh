#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/system-info.sh
source "$SCRIPT_DIR/../lib/system-info.sh"

usage() {
    cat <<'EOF'
Usage:
  system-report.sh [OPTIONS]

Options:
  --output FILE   Save a plain-text system report to FILE.
  --no-color      Disable colored terminal output.
  -h, --help      Show this help message.

Examples:
  ./bin/system-report.sh
  ./bin/system-report.sh --no-color
  ./bin/system-report.sh --output system-report.status
EOF
}

render_report() {
    local use_color="$1"
    local key

    local -a keys=(
        HOSTNAME
        TIMEZONE
        USER
        OS
        DATE
        UPTIME
        UPTIME_SEC
        IP_CIDR
        DEFAULT_GATEWAY
        RAM_TOTAL_GIB
        RAM_USED_GIB
        RAM_AVAILABLE_GIB
        ROOT_TOTAL_GIB
        ROOT_USED_GIB
        ROOT_AVAILABLE_GIB
    )

    for key in "${keys[@]}"; do
        if [[ "$use_color" == "true" ]]; then
            printf '\033[1;36m%-22s\033[0m = \033[0;32m%s\033[0m\n' \
                "$key" "${SYSTEM_INFO[$key]}"
        else
            printf '%-22s = %s\n' "$key" "${SYSTEM_INFO[$key]}"
        fi
    done
}

output_file=""
color_mode="auto"

while (($# > 0)); do
    case "$1" in
        --output)
            if (($# < 2)) || [[ -z "$2" ]]; then
                printf 'Error: --output requires a file path.\n' >&2
                exit 2
            fi
            output_file="$2"
            shift 2
            ;;
        --no-color)
            color_mode="never"
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            printf 'Error: unknown option: %s\n\n' "$1" >&2
            usage >&2
            exit 2
            ;;
    esac
done

collect_system_info

if [[ -n "$output_file" ]]; then
    if ! render_report false > "$output_file"; then
        printf 'Error: could not write report to %s\n' "$output_file" >&2
        exit 1
    fi
    printf 'Report saved to %s\n' "$output_file" >&2
fi

use_color="false"
if [[ "$color_mode" == "auto" && -t 1 && -z "${NO_COLOR:-}" ]]; then
    use_color="true"
fi

render_report "$use_color"
