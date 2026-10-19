#!/bin/bash

format_colors() {
    COLOR_WHITE=47
    COLOR_RED=41
    COLOR_GREEN=42
    COLOR_BLUE=44
    COLOR_PURPLE=45
    COLOR_BLACK=40

    FONT_WHITE=37
    FONT_RED=31
    FONT_GREEN=32
    FONT_BLUE=34
    FONT_PURPLE=35
    FONT_BLACK=30
    
    RESET_COLOR="\e[0m"
 	
    bg_names=$COLOR_WHITE
    font_names=$FONT_BLACK
    bg_values=$COLOR_PURPLE
    font_values=$FONT_BLUE

    case $1 in
        1) bg_names=$COLOR_WHITE ;;
        2) bg_names=$COLOR_RED ;;
        3) bg_names=$COLOR_GREEN ;;
        4) bg_names=$COLOR_BLUE ;;
        5) bg_names=$COLOR_PURPLE ;;
        6) bg_names=$COLOR_BLACK ;;
    esac

    case $2 in
        1) font_names=$FONT_WHITE ;;
        2) font_names=$FONT_RED ;;
        3) font_names=$FONT_GREEN ;;
        4) font_names=$FONT_BLUE ;;
        5) font_names=$FONT_PURPLE ;;
        6) font_names=$FONT_BLACK ;;
    esac

    case $3 in
        1) bg_values=$COLOR_WHITE ;;
        2) bg_values=$COLOR_RED ;;
        3) bg_values=$COLOR_GREEN ;;
        4) bg_values=$COLOR_BLUE ;;
        5) bg_values=$COLOR_PURPLE ;;
        6) bg_values=$COLOR_BLACK ;;
    esac

    case $4 in
        1) font_values=$FONT_WHITE ;;
        2) font_values=$FONT_RED ;;
        3) font_values=$FONT_GREEN ;;
        4) font_values=$FONT_BLUE ;;
        5) font_values=$FONT_PURPLE ;;
        6) font_values=$FONT_BLACK ;;
    esac
}


