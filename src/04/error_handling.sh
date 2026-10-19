#!/bin/bash

handle_errors() {
    error=0
    if [[ "$#" -gt 4 ]]; then
        echo -e "ERROR #1: This script may handle no more than 4 numeric parameters!\n\n\t  Please provide relevant quantity of parameters and with accordance to a required parameters' type."
        error=1
    elif [[ "$1" -eq "$2" ]] && [[ "$1" ]] && [[ "$2" ]]; then
        echo -e "ERROR #4: The font and background colors of the value names cannot match!\n\n\t  Please call the script again with different parameters."
        error=4
    elif [[ "$3" -eq "$4" ]] && [[ "$3" ]] && [[ "$4" ]]; then
        echo -e "ERROR #5: The font and background colors of the values cannot match!\n\n\t  Please call the script again with different parameters."
        error=5
    fi

    for param in "$@"; do
        if (! [[ "$param" =~ ^[0-9]+$ ]]) && [[ "$param" ]] && [[ $error -eq 0 ]]; then
            echo -e "ERROR #2: All parameters must be numeric!\n\n\t  Please provide relevant parameters for this script."
            error=2
    	elif ([[ "$param" -lt 1 ]] || [[ "$param" -gt 6 ]]) && [[ "$param" ]] && [[ $error -eq 0 ]]; then
            echo -e "ERROR #3: Parameters must be between 1 and 6!\n\n\t  Please provide relevant parameters for this script."
            error=3
        fi
    done

    return $error
}

handle_entry_error() {
	error=0
	if [[ "$#" -ne 0 ]]; then
		echo -e "ERROR #7: This script does not accept any entry arguments!\n\n\t  If you would like to provide any — please add your numeric arguments into config.conf file in front of corresponding variables.\n\n\t  Afterwards launch the script again without any entry arguments."
	error=7
	fi

	return $error
}
