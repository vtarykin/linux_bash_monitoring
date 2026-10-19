#!/bin/bash

chmod +x main.sh system_info.sh error_handling.sh set_messages.sh format_colors.sh output_info.sh

source ./format_colors.sh
source ./system_info.sh
source ./error_handling.sh
source ./output_info.sh
source ./set_messages.sh
handle_entry_error $@
error=$?
if [[ $error -eq 0 ]]; then
	source "config.conf"

	c1b=$column1_background
	c1f=$column1_font_color
	c2b=$column2_background
	c2f=$column2_font_color

	handle_errors "$c1b" "$c1f" "$c2b" "$c2f"

	error=$?
fi

if [[ $error -eq 0 ]]; then

	format_colors "$c1b" "$c1f" "$c2b" "$c2f"
	set_messages "$c1b" "$c1f" "$c2b" "$c2f"
	get_system_info
	output_info
	output_config_messages
fi

exit $error
