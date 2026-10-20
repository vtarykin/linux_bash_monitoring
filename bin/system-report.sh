#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

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
  --format FORMAT  Output format: text or json (default: text).
  --output FILE    Save the report to FILE.
  --no-color       Disable colored terminal output.
  -h, --help       Show this help message.

Examples:
  ./bin/system-report.sh
  ./bin/system-report.sh --no-color
  ./bin/system-report.sh --format json
  ./bin/system-report.sh --format json --output system-report.json
  ./bin/system-report.sh --output system-report.status
EOF
}

json_escape() {
    local value="$1"

    value="${value//\\/\\\\}"
    value="${value//\"/\\\"}"
    value="${value//$'\b'/\\b}"
    value="${value//$'\f'/\\f}"
    value="${value//$'\n'/\\n}"
    value="${value//$'\r'/\\r}"
    value="${value//$'\t'/\\t}"

    printf '%s' "$value"
}

render_text() {
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

render_json() {
    local key
    local json_key
    local value
    local separator=""

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

    printf '{\n'

    for key in "${keys[@]}"; do
        json_key="${key,,}"
        value="${SYSTEM_INFO[$key]}"

        printf '%s  "%s": ' "$separator" "$json_key"

        case "$key" in
            UPTIME_SEC|RAM_TOTAL_GIB|RAM_USED_GIB|RAM_AVAILABLE_GIB|ROOT_TOTAL_GIB|ROOT_USED_GIB|ROOT_AVAILABLE_GIB)
                if [[ "$value" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
                    printf '%s' "$value"
                else
                    printf '"'
                    json_escape "$value"
                    printf '"'
                fi
                ;;
            *)
                printf '"'
                json_escape "$value"
                printf '"'
                ;;
        esac

        separator=$',\n'
    done

    printf '\n}\n'
}

render_report() {
    local use_color="$1"

    if [[ "$output_format" == "json" ]]; then
        render_json
    else
        render_text "$use_color"
    fi
}

output_file=""
output_format="text"
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
        --format)
            if (($# < 2)) || [[ -z "$2" ]]; then
                printf 'Error: --format requires text or json.\n' >&2
                exit 2
            fi

            case "$2" in
                text|json)
                    output_format="$2"
                    ;;
                *)
                    printf 'Error: unsupported output format: %s\n' "$2" >&2
                    printf 'Supported formats: text, json.\n' >&2
                    exit 2
                    ;;
            esac

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

if [[ "$(uname -s)" != "Linux" ]]; then
    printf 'Error: this utility requires Linux.\n' >&2
    printf 'Current environment: %s\n' "$(uname -s)" >&2
    exit 1
fi

collect_system_info

if [[ -n "$output_file" ]]; then
    if ! render_report false > "$output_file"; then
        printf 'Error: could not write report to %s\n' "$output_file" >&2
        exit 1
    fi

    printf 'Report saved to %s\n' "$output_file" >&2
fi

use_color="false"

if [[ "$output_format" == "text" &&
      "$color_mode" == "auto" &&
      -t 1 &&
      -z "${NO_COLOR:-}" ]]; then
    use_color="true"
fi

render_report "$use_color"
