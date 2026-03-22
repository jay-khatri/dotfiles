#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Custom Screenshot
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Screenshot command which renders the default macOS screenshot UI, saves the screenshot to a tmp/ file, then copies the screenshot path to the clipboard. Useful for pasting screenshot paths into claude code. 
# @raycast.author jay_khatri
# @raycast.authorURL https://raycast.com/jay_khatri

# Create temp file with timestamp
TEMP_FILE="/tmp/screenshot-$(date +%Y%m%d-%H%M%S).png"

# Run screencapture with interactive selection (-i), suppress sound (-x)
screencapture -i -x "$TEMP_FILE"

# Check if file was created (user might have cancelled with Escape)
if [ -f "$TEMP_FILE" ]; then
    # Copy the file path to clipboard
    echo -n "$TEMP_FILE" | pbcopy
else
    exit 1
fi