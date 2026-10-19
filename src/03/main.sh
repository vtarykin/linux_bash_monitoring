#!/bin/bash

chmod +x main.sh system_info.sh error_handling.sh format_colors.sh output_info.sh

source ./format_colors.sh
source ./system_info.sh
source ./error_handling.sh
source ./output_info.sh
handle_errors "$@"
error=$?

if [[ $error -eq 0 ]]; then

	format_colors "$@"

	get_system_info

	output_info
fi

exit $error
