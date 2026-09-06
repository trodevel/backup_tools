#!/bin/bash

PASSWORD=""
NOCACHE=false

# Parse long and short options using getopt
PARSED_ARGS=$(getopt -o p: --long nocache -- "$@")
if [ $? -ne 0 ]; then
  echo "Error: Invalid argument passed." >&2
  exit 1
fi

eval set -- "$PARSED_ARGS"

while true; do
  case "$1" in
    -p)
      PASSWORD="$2"
      shift 2
      ;;
    --nocache)
      NOCACHE=true
      shift
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "Error: Unexpected option processing." >&2
      exit 1
      ;;
  esac
done

# Exit with error if unexpected extra arguments remain
if [ $# -gt 0 ]; then
  echo "Error: Unexpected positional argument(s): $*" >&2
  exit 1
fi

# Ensure destination directory exists
mkdir -p "$HOME/backup"

# Generate timestamped filename
TIMESTAMP=$(date +"%Y-%m-%d_%H%M")

# Build exclusion array
EXCLUDES=("--exclude=$HOME/backup")

if [ "$NOCACHE" = true ]; then
  EXCLUDES+=("--exclude=$HOME/.cache")
  EXCLUDES+=("--exclude=$HOME/.mozilla/firefox/*.default*/cache2")
  EXCLUDES+=("--exclude=$HOME/.mozilla/firefox/*.default-release*/cache2")
fi

# Unencrypted Backup Path
BACKUP_FILE="$HOME/backup/backup_home_${USER}_${TIMESTAMP}.tar.gz"


# Run backup depending on encryption flag
if [ -n "$PASSWORD" ]; then
  # Encrypted Backup Path
  BACKUP_FILE="${BACKUP_FILE}.gpg"

  tar -czv "${EXCLUDES[@]}" -C "$HOME" . | \
    gpg --symmetric --batch --yes --passphrase "$PASSWORD" -o "$BACKUP_FILE"
else

  tar -czvf "$BACKUP_FILE" "${EXCLUDES[@]}" -C "$HOME" .
fi
