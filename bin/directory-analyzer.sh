#!/usr/bin/env bash

set -Eeuo pipefail

usage() {
    cat <<'EOF'
Usage:
  directory-analyzer.sh DIRECTORY

Analyze files and directories within DIRECTORY.

Options:
  -h, --help    Show this help message.

Examples:
  ./bin/directory-analyzer.sh /var/log
  ./bin/directory-analyzer.sh "/home/user/My Documents"
EOF
}

if (($# == 1)) && [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
    exit 0
fi

if [[ "$(uname -s)" != "Linux" ]]; then
    printf 'Error: this utility requires Linux.\n' >&2
    exit 1
fi

if (($# != 1)); then
    printf 'Error: exactly one directory argument is required.\n\n' >&2
    usage >&2
    exit 2
fi

if [[ ! -d "$1" ]]; then
    printf 'Error: directory does not exist: %s\n' "$1" >&2
    exit 2
fi

if ! TARGET_DIR="$(cd -- "$1" 2>/dev/null && pwd -P)"; then
    printf 'Error: cannot access directory: %s\n' "$1" >&2
    exit 2
fi

if [[ "$TARGET_DIR" == "/" ]]; then
    printf 'Error: analyzing the root directory is disabled.\n' >&2
    printf 'Specify a narrower directory to avoid scanning the entire filesystem.\n' >&2
    exit 2
fi

required_commands=(
    find
    du
    sort
    stat
    numfmt
    file
    mktemp
    date
    wc
    head
)

for command_name in "${required_commands[@]}"; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
        printf 'Error: required command not found: %s\n' "$command_name" >&2
        exit 1
    fi
done

TEMP_DIR="$(mktemp -d)"
ERROR_LOG="$TEMP_DIR/scan-errors.log"

trap 'rm -rf -- "$TEMP_DIR"' EXIT

: > "$ERROR_LOG"

count_matches() {
    local count

    count="$(
        {
            find "$TARGET_DIR" "$@" -printf '.' \
                2>> "$ERROR_LOG" || true
        } | wc -c
    )"

    count="${count//[[:space:]]/}"
    printf '%s\n' "$count"
}

build_file_records() {
    local root="$1"
    local output_file="$2"
    local path
    local size

    shift 2

    while IFS= read -r -d '' path; do
        if size="$(stat -c '%s' -- "$path" 2>> "$ERROR_LOG")"; then
            if [[ "$size" =~ ^[0-9]+$ ]]; then
                printf '%s\t%s\0' "$size" "$path"
            fi
        fi
    done < <(
        find "$root" "$@" -print0 2>> "$ERROR_LOG"
    ) |
        LC_ALL=C sort -z -t $'\t' -k1,1nr > "$output_file"
}

print_largest_directories() {
    local index=0
    local record
    local size
    local path

    while IFS= read -r -d '' record; do
        size="${record%%$'\t'*}"
        path="${record#*$'\t'}"

        # Exclude the target directory itself.
        [[ "$path" == "$TARGET_DIR" ]] && continue

        index=$((index + 1))

        printf '  %2d. %s | %s\n' \
            "$index" \
            "$(printf '%q' "$path")" \
            "$(numfmt --to=iec-i --suffix=B "$size")"

        if ((index >= 5)); then
            break
        fi
    done < "$TEMP_DIR/directories.sorted"

    if ((index == 0)); then
        printf '  No subdirectories found.\n'
    fi
}

print_largest_files() {
    local records_file="$1"
    local limit="$2"
    local show_type="$3"

    local index=0
    local record
    local size
    local path
    local mime_type
    local human_size

    while IFS= read -r -d '' record; do
        size="${record%%$'\t'*}"
        path="${record#*$'\t'}"
        human_size="$(numfmt --to=iec-i --suffix=B "$size")"

        index=$((index + 1))

        if [[ "$show_type" == "yes" ]]; then
            mime_type="$(
                file -b --mime-type -- "$path" 2>/dev/null ||
                    printf 'unknown'
            )"

            printf '  %2d. %s | %s | %s\n' \
                "$index" \
                "$(printf '%q' "$path")" \
                "$human_size" \
                "$mime_type"
        else
            printf '  %2d. %s | %s\n' \
                "$index" \
                "$(printf '%q' "$path")" \
                "$human_size"
        fi

        if ((index >= limit)); then
            break
        fi
    done < "$records_file"

    if ((index == 0)); then
        printf '  No matching files found.\n'
    fi
}

start_time="$(date +%s%N)"

directory_count="$(count_matches -type d)"
file_count="$(count_matches -type f)"
config_count="$(count_matches -type f -iname '*.conf')"
text_count="$(count_matches -type f -iname '*.txt')"
executable_count="$(count_matches -type f -perm /111)"
log_count="$(count_matches -type f -iname '*.log')"
archive_count="$(
    count_matches -type f \
        \( -iname '*.zip' \
        -o -iname '*.tar' \
        -o -iname '*.gz' \
        -o -iname '*.tgz' \
        -o -iname '*.bz2' \
        -o -iname '*.xz' \
        -o -iname '*.7z' \)
)"
symlink_count="$(count_matches -type l)"

LC_ALL=C sort -z -t $'\t' -k1,1nr \
    < <(du -B1 --null -- "$TARGET_DIR" 2>> "$ERROR_LOG") \
    > "$TEMP_DIR/directories.sorted"

build_file_records \
    "$TARGET_DIR" "$TEMP_DIR/files.sorted" \
    -type f

build_file_records \
    "$TARGET_DIR" "$TEMP_DIR/executables.sorted" \
    -type f -perm /111

end_time="$(date +%s%N)"
elapsed_ns=$((end_time - start_time))

printf 'Directory Analysis Report\n'
printf '=========================\n'
printf 'Target directory: %s\n\n' "$(printf '%q' "$TARGET_DIR")"

printf 'Summary\n'
printf '  Directories (including target): %s\n' "$directory_count"
printf '  Files: %s\n' "$file_count"
printf '  Configuration files (.conf): %s\n' "$config_count"
printf '  Text files (.txt): %s\n' "$text_count"
printf '  Executable files: %s\n' "$executable_count"
printf '  Log files (.log): %s\n' "$log_count"
printf '  Archive files: %s\n' "$archive_count"
printf '  Symbolic links: %s\n' "$symlink_count"

printf '\nLargest subdirectories (disk usage)\n'
print_largest_directories

printf '\nLargest files (logical file size)\n'
print_largest_files "$TEMP_DIR/files.sorted" 10 yes

printf '\nLargest executable files\n'
print_largest_files "$TEMP_DIR/executables.sorted" 10 no

printf '\nExecution time: %d.%03d seconds\n' \
    "$((elapsed_ns / 1000000000))" \
    "$(((elapsed_ns % 1000000000) / 1000000))"

if [[ -s "$ERROR_LOG" ]]; then
    printf '\nWarning: some entries could not be inspected. Results may be incomplete.\n' >&2
    head -n 10 "$ERROR_LOG" >&2

    if [[ "$(wc -l < "$ERROR_LOG")" -gt 10 ]]; then
        printf 'Additional errors omitted.\n' >&2
    fi
fi
