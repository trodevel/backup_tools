#!/bin/bash

PASSWORD=""

# Parse command line options
while getopts ":p:" opt; do
  case ${opt} in
    p )
      PASSWORD="$OPTARG"
      ;;
    \? )
      echo "Error: Invalid option -$OPTARG" >&2
      exit 1
      ;;
    : )
      echo "Error: Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Shift to check for extraneous positional arguments
shift $((OPTIND -1))

if [ $# -gt 0 ]; then
  echo "Error: Unexpected positional arguments provided." >&2
  exit 1
fi

# Ensure destination directory exists
mkdir -p "$HOME/backup"

# Generate timestamped filename
TIMESTAMP=$(date +"%Y-%m-%d_%H%M")

if [ -n "$PASSWORD" ]; then
  # Encrypted Backup Path
  BACKUP_FILE="$HOME/backup/backup_home_${USER}_${TIMESTAMP}.tar.gz.gpg"

  tar -czv \
      --exclude="$HOME/backup" \
      --exclude="$HOME/.cache" \
      --exclude="$HOME/.mozilla/firefox/*.default*/cache2" \
      --exclude="$HOME/.mozilla/firefox/*.default-release*/cache2" \
      -C "$HOME" . | gpg --symmetric --batch --yes --passphrase "$PASSWORD" -o "$BACKUP_FILE"
else
  # Unencrypted Backup Path
  BACKUP_FILE="$HOME/backup/backup_home_${USER}_${TIMESTAMP}.tar.gz"

  tar -czvf "$BACKUP_FILE" \
      --exclude="$HOME/backup" \
      --exclude="$HOME/.cache" \
      --exclude="$HOME/.mozilla/firefox/*.default*/cache2" \
      --exclude="$HOME/.mozilla/firefox/*.default-release*/cache2" \
      -C "$HOME" .
fi
