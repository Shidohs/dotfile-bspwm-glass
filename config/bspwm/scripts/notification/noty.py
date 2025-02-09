#!/usr/bin/env python3

import subprocess
import sys

# Check if the user provided a notification message
if len(sys.argv) < 2:
    print("Please provide a notification message")
    sys.exit(1)

# Get the notification message from the command line.
message = sys.argv[1]

# Send the notification to bspwm.
try:
    subprocess.run(["bspc", "notification", "-t", "5000", message], check=True)
except subprocess.CalledProcessError as e:
    print(f"An error occurred: {e}")
