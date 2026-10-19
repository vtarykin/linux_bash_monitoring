#!/bin/bash

# not_a_digit=$( echo $1 | awk '/[[:digit:]]/{print $0}')
chmod +x ./*
./error_handling.sh "$@"
error=$?

if [ $error -eq 0 ]; then
    echo "$1"
fi
exit $error
