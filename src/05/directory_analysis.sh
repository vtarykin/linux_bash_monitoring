#!/bin/bash

analyze_directory() {
    local dir_path="$1"

    total_folders=$(find "$dir_path" -type d | wc -l)

    top_folders=$(du -h "$dir_path" | sort -rh | head -n 5 | awk '{print NR " - " $2 ", " $1}')

    total_files=$(find "$dir_path" -type f | wc -l)

    config_files=$(find "$dir_path" -type f -name "*.conf" | wc -l)
    text_files=$(find "$dir_path" -type f -name "*.txt" | wc -l)
    executable_files=$(find "$dir_path" -type f -executable | wc -l)
    log_files=$(find "$dir_path" -type f -name "*.log" | wc -l)
    archive_files=$(find "$dir_path" -type f \( -name "*.zip" -o -name "*.tar" -o -name "*.gz" \) | wc -l)
    symbolic_links=$(find "$dir_path" -type l | wc -l)

    #  type=$(file -b --mime-type "$dir_path" | cut -d '/' -f2)
    #  $(file -b --mime-type $2 | cut -d '/' -f2 )
    #  system("file -b --mime-type " $2 " | cut -d '/' -f2 ")
    top_files=$(find "$dir_path" -type f -exec du -h {} + | sort -rh | head -n 10 | awk '{print NR " - " $2 ", " $1 ", " }')
    top_files_type=$(find "$dir_path" -type f -exec du -h {} + | sort -rh | head -n 10 | file -b --mime-type $(awk '{print $2}') | cut -d '/' -f2 | cut -d '-' -f2)
    
    top_executable_files=$(find "$dir_path" -type f -executable -exec du -h {} + | sort -rh | head -n 10 | awk '{print NR " - " $2 ", " $1 ", " substr($2, match($2, /[^.]+$/))}')
    top_executable_files_hash=$(find "$dir_path" -type f -executable -exec du -h {} + | sort -rh | head -n 10 | awk '{print $2}' | xargs -I {} md5sum {} | awk '{print $1}')

}

