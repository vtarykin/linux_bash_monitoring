#!/bin/bash

chmod +x main.sh system_info.sh error_handling.sh write_to_file.sh

source ./system_info.sh
source ./error_handling.sh
source ./write_to_file.sh

handle_errors "$@"
error=$?

if [[ $error -eq 0 ]]; then
	get_system_info

	output_system_info

	write_to_file_prompt
fi
exit $error
