#!/bin/bash

# Check if the user provided a notification message
if [ $# -lt 1 ]; then
    echo "Please provide a notification message"
    exit 1
fi

# Get the notification message from the command line.
message=$1

# Send the notification to bspwm.
if ! bspc notification -t 5000 "$message"; then
    echo "An error occurred"
fi
