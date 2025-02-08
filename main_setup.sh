#!/bin/bash

# Prompt the user for the base directory
read -p "Enter the base directory for Protheus installation: " BASE_DIR

# Call the setup_folders.sh script with the base directory
bash ./setup_folders.sh "$BASE_DIR"

# Call the setup_files.sh script with the base directory
bash ./setup_files.sh "$BASE_DIR"
