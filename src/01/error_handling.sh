#!/bin/bash
error=0
if [ $# -eq 0 ]; then
    #echo "Error: No arguments provided."
    echo -e "ERROR #1: No parameters found!\n\n\t  Please provide ONLY ONE text parameter."
    error=1
elif [ $# -gt 1 ]; then
    #echo "Error: More than one argument provided."
    echo -e "ERROR #2: Too much parameters!\n\n\t  Please provide only one parameter."
    error=2

elif [[ "$1" =~ ^[0-9]+$ ]]; then
    #echo "Error: Argument is a digit."
    echo -e "ERROR #3: The presence of any digits as a parameter is prohibited!\n\n\t  Please provide only text parameter without any digits."
    error=3
fi

exit $error

