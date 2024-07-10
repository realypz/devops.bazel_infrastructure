#!/bin/bash

# String containing the Clang version
clang_version="Homebrew clang version 18.1.8"

# Extract the version number using regex
version_number=$(echo "$clang_version" | grep -oE 'clang version [0-9]+\.[0-9]+\.[0-9]+' | grep -oE '[0-9]+\.[0-9]+\.[0-9]'  | head -n 1)

# Print the version number
echo "$version_number"
