#!/bin/bash

# Copyright message
COPYRIGHT_MSG="/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/"
# Function to check if the copyright message already exists in a file
has_copyright() {
    grep -qF "$COPYRIGHT_MSG" "$1"
}

# Function to add copyright message to a file if it doesn't already exist
add_copyright() {
    if grep -qF "Copyright" "$1"; then
       echo "Copyright message already exists in $1"
    else
       # Prepend the copyright message to the beginning of the file
        echo "$COPYRIGHT_MSG" | cat - "$1" > temp && mv temp "$1"
        echo "Added copyright message to $1"
    fi
}

# Find all .dart files recursively and execute the function on each file
find lib -type f -name "*.dart" | while read file; do
    add_copyright "$file"
done