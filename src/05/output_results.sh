#!/bin/bash

output_results() {
    echo "Total number of folders (including all nested ones) = $total_folders"
    echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
    echo "$top_folders"
    echo "Total number of files = $total_files"
    echo "Number of:"
    echo "Configuration files (with the .conf extension) = $config_files"
    echo "Text files = $text_files"
    echo "Executable files = $executable_files"
    echo "Log files (with the extension .log) = $log_files"
    echo "Archive files = $archive_files"
    echo "Symbolic links = $symbolic_links"
    echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
    #echo "$top_files"
    paste <(echo "$top_files") <(echo "$top_files_type") | awk '{print $1 " " $2 " " $3 " " $4 " " $5}'
    echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):"
    #paste <(echo "$top_executable_files") <(echo "$top_executable_files_hash") | awk '{print $1 " " $2 " " $3 ", " $4}'
    paste <(echo "$top_executable_files") <(echo "$top_executable_files_hash") | awk '{print $1 " " $2 " " $3 " " $4 " " $6}'
}

output_processing_time() {
	get_time
	echo "Script execution time (in seconds) = $elapsed_seconds"	
}
