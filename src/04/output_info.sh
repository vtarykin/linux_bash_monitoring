#!/bin/bash

output_info() {
    echo -e "\e[${bg_names};${font_names}m HOSTNAME $RESET_COLOR = \e[${bg_values};${font_values}m $HOSTNAME $RESET_COLOR"
    echo -e "\e[${bg_names};${font_names}m TIMEZONE $RESET_COLOR = \e[${bg_values};${font_values}m $TIMEZONE $RESET_COLOR"
    echo -e "\e[${bg_names};${font_names}m USER $RESET_COLOR = \e[${bg_values};${font_values}m $USER $RESET_COLOR"
    echo -e "\e[${bg_names};${font_names}m OS $RESET_COLOR = \e[${bg_values};${font_values}m $OS $RESET_COLOR"
    echo -e "\e[${bg_names};${font_names}m DATE $RESET_COLOR = \e[${bg_values};${font_values}m $DATE $RESET_COLOR"
    echo -e "\e[${bg_names};${font_names}m UPTIME $RESET_COLOR = \e[${bg_values};${font_values}m $UPTIME $RESET_COLOR"
    echo -e "\e[${bg_names};${font_names}m UPTIME_SEC $RESET_COLOR = \e[${bg_values};${font_values}m $UPTIME_SEC $RESET_COLOR"
    echo -e "\e[${bg_names};${font_names}m IP $RESET_COLOR = \e[${bg_values};${font_values}m $IP $RESET_COLOR"
    echo -e "\e[${bg_names};${font_names}m MASK $RESET_COLOR = \e[${bg_values};${font_values}m $MASK $RESET_COLOR"
    echo -e "\e[${bg_names};${font_names}m GATEWAY $RESET_COLOR = \e[${bg_values};${font_values}m $GATEWAY $RESET_COLOR"
    echo -e "\e[${bg_names};${font_names}m RAM_TOTAL $RESET_COLOR = \e[${bg_values};${font_values}m $RAM_TOTAL $RESET_COLOR"
    echo -e "\e[${bg_names};${font_names}m RAM_USED $RESET_COLOR = \e[${bg_values};${font_values}m $RAM_USED $RESET_COLOR"
    echo -e "\e[${bg_names};${font_names}m RAM_FREE $RESET_COLOR = \e[${bg_values};${font_values}m $RAM_FREE $RESET_COLOR"
    echo -e "\e[${bg_names};${font_names}m SPACE_ROOT $RESET_COLOR = \e[${bg_values};${font_values}m $SPACE_ROOT $RESET_COLOR"
    echo -e "\e[${bg_names};${font_names}m SPACE_ROOT_USED $RESET_COLOR = \e[${bg_values};${font_values}m $SPACE_ROOT_USED $RESET_COLOR"
    echo -e "\e[${bg_names};${font_names}m SPACE_ROOT_FREE $RESET_COLOR = \e[${bg_values};${font_values}m $SPACE_ROOT_FREE $RESET_COLOR"
}

output_config_messages() {

	echo -e "\n$message1\n$message2\n$message3\n$message4"
}
