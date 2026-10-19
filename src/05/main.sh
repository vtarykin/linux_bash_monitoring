#!/bin/bash
chmod +x main.sh process_timer.sh error_handling.sh directory_analysis.sh output_results.sh
source ./process_timer.sh
start_timer
source ./error_handling.sh
source ./directory_analysis.sh
source ./output_results.sh

handle_errors "$@"
error=$?
if [[ $error -eq 0 ]]; then
	analyze_directory "$1"
	output_results "$1"
	stop_timer
	output_processing_time
else
	stop_timer
fi
exit $error
