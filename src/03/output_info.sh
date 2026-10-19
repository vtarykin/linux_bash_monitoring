#!/bin/bash

output_info() {
    echo -e "\e[${bg_names};${font_names}m HOSTNAME \e[0m = \e[${bg_values};${font_values}m $HOSTNAME \e[0m"
    echo -e "\e[${bg_names};${font_names}m TIMEZONE \e[0m = \e[${bg_values};${font_values}m $TIMEZONE \e[0m"
    echo -e "\e[${bg_names};${font_names}m USER \e[0m = \e[${bg_values};${font_values}m $USER \e[0m"
    echo -e "\e[${bg_names};${font_names}m OS \e[0m = \e[${bg_values};${font_values}m $OS \e[0m"
    echo -e "\e[${bg_names};${font_names}m DATE \e[0m = \e[${bg_values};${font_values}m $DATE \e[0m"
    echo -e "\e[${bg_names};${font_names}m UPTIME \e[0m = \e[${bg_values};${font_values}m $UPTIME \e[0m"
    echo -e "\e[${bg_names};${font_names}m UPTIME_SEC \e[0m = \e[${bg_values};${font_values}m $UPTIME_SEC \e[0m"
    echo -e "\e[${bg_names};${font_names}m IP \e[0m = \e[${bg_values};${font_values}m $IP \e[0m"
    echo -e "\e[${bg_names};${font_names}m MASK \e[0m = \e[${bg_values};${font_values}m $MASK \e[0m"
    echo -e "\e[${bg_names};${font_names}m GATEWAY \e[0m = \e[${bg_values};${font_values}m $GATEWAY \e[0m"
    echo -e "\e[${bg_names};${font_names}m RAM_TOTAL \e[0m = \e[${bg_values};${font_values}m $RAM_TOTAL \e[0m"
    echo -e "\e[${bg_names};${font_names}m RAM_USED \e[0m = \e[${bg_values};${font_values}m $RAM_USED \e[0m"
    echo -e "\e[${bg_names};${font_names}m RAM_FREE \e[0m = \e[${bg_values};${font_values}m $RAM_FREE \e[0m"
    echo -e "\e[${bg_names};${font_names}m SPACE_ROOT \e[0m = \e[${bg_values};${font_values}m $SPACE_ROOT \e[0m"
    echo -e "\e[${bg_names};${font_names}m SPACE_ROOT_USED \e[0m = \e[${bg_values};${font_values}m $SPACE_ROOT_USED \e[0m"
    echo -e "\e[${bg_names};${font_names}m SPACE_ROOT_FREE \e[0m = \e[${bg_values};${font_values}m $SPACE_ROOT_FREE \e[0m"
}

