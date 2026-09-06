#!/bin/bash

# Create destination directory if it doesn't exist
mkdir -p "$HOME/backup"

# Generate timestamped filename
TIMESTAMP=$(date +"%Y-%m-%d_%H%M")
BACKUP_FILE="$HOME/backup/backup_home_${USER}_${TIMESTAMP}.tar.gz"

# Run tar backup with exclusions
tar -czvf "$BACKUP_FILE" \
    --exclude="$HOME/backup" \
    --exclude="$HOME/.cache" \
    --exclude="$HOME/.mozilla/firefox/*.default*/cache2" \
    --exclude="$HOME/.mozilla/firefox/*.default-release*/cache2" \
    -C "$HOME" .
