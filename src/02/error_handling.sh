#!/bin/bash

handle_errors() {
    error=0
    if [ $# -ne 0 ]; then
        echo -e "ERROR:  This script does not accept any arguments!\n\n\tPlease try to launch script again without any arguments."
        error=1
    fi
    return $error
}

