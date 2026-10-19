#!/bin/bash

handle_errors() {
    
    error=0

    if [ $# -ne 1 ]; then
        echo -e "ERROR #1: This script requires exactly one parameter!\n\n\t  Please provide only one parameter representing a directory path ending with '/'."
        error=1
    elif [[ "$1" != */ ]] || [[ "$1" == "/" ]]; then
        echo -e "ERROR #2: The parameter must be a directory path ending with '/'!\n\n\t  Please provide directory path in accordance to scripts' requirment."
        error=2
    elif [ ! -d "$1" ]; then
        echo -e "ERROR #3: The specified directory does not exist.\n\n\t  Please provide directory path of an existing directory."
        error=3
    fi
    return $error
}

