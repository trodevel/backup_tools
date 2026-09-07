# Home Directory Backup Script (`create_backup_home.sh`)

A robust Bash script designed to create compressed (`.tar.gz`) and optionally encrypted (`.gpg`) backups of a user's home directory (`$HOME`).

---

## Features

- **Automated Compression:** Bundles and compresses the home directory into a `.tar.gz` archive.
- **Optional GPG Encryption:** Encrypts backups on the fly using AES/GPG symmetric key encryption (`.tar.gz.gpg`).
- **Flexible Cache Handling:** Excludes backup folders by default while offering an optional flag (`--nocache`) to skip temporary cache files and browser caches.
- **Timestamped File Naming:** Auto-generates filenames following the standard format: `backup_home_${USER}_YYYY-MM-DD_HHMM.tar.gz[.gpg]`.
- **Safe Directory Navigation:** Archives relative paths starting from `$HOME` to avoid absolute path lock-in when extracting.

---

## Directory Structure & Default Exclusions

By default, backups are saved to:
```text
$HOME/backup/backup_home_${USER}_YYYY-MM-DD_HHMM.tar.gz
```

### Exclusions Summary

| Excluded Directory / Files | Always Excluded? | Excluded with `--nocache` |
| :--- | :---: | :---: |
| `$HOME/backup/` | **Yes** | **Yes** |
| `$HOME/.cache/` | No | **Yes** |
| Firefox Cache (`~/.mozilla/firefox/*.default*/cache2`) | No | **Yes** |

> **Note:** Excluding `$HOME/backup` prevents recursive loops where a backup includes prior backup files.

---

## Setup & Installation

1. **Download / Save the script** as `create_backup_home.sh`.
2. **Make the script executable:**
   ```bash
   chmod +x create_backup_home.sh
   ```

---

## Usage Syntax

```bash
./create_backup_home.sh [-p <password>] [--nocache]
```

### Command Line Options

| Parameter | Short | Description |
| :--- | :--- | :--- |
| `-p <password>` | `-p` | Passphrase used to symmetrically encrypt the backup file using `gpg`. |
| `--nocache` | N/A | Excludes `.cache` and Firefox cache directories from the archive. |

---

## Examples

### 1. Default Backup (Includes cache, excludes `$HOME/backup`)
```bash
./create_backup_home.sh
```
*Output File:* `~/backup/backup_home_username_2026-09-07_2245.tar.gz`

---

### 2. Backup Excluding Cache
```bash
./create_backup_home.sh --nocache
```
*Output File:* `~/backup/backup_home_username_2026-09-07_2245.tar.gz`

---

### 3. Encrypted Backup with Password
```bash
./create_backup_home.sh -p "MySecretPassword123"
```
*Output File:* `~/backup/backup_home_username_2026-09-07_2245.tar.gz.gpg`

---

### 4. Encrypted Backup without Cache
```bash
./create_backup_home.sh -p "MySecretPassword123" --nocache
```
*Output File:* `~/backup/backup_home_username_2026-09-07_2245.tar.gz.gpg`

---

## Restoring & Inspecting Backups

### Inspect Archive Contents
- **Unencrypted Archive:**
  ```bash
  tar -ztvf ~/backup/backup_home_username_2026-09-07_2245.tar.gz
  ```
- **Encrypted Archive:**
  ```bash
  gpg -d ~/backup/backup_home_username_2026-09-07_2245.tar.gz.gpg | tar -ztv
  ```

---

### Extracting Archives

To extract the backup contents into a target directory (e.g., `/tmp/restore`):

1. **Create target directory:**
   ```bash
   mkdir -p /tmp/restore
   ```

2. **Extract Unencrypted Backup:**
   ```bash
   tar -xzvf ~/backup/backup_home_username_2026-09-07_2245.tar.gz -C /tmp/restore
   ```

3. **Decrypt and Extract Encrypted Backup:**
   ```bash
   gpg -d ~/backup/backup_home_username_2026-09-07_2245.tar.gz.gpg | tar -xz -C /tmp/restore
   ```

---

## Troubleshooting & Verification

To verify that the `$HOME/backup` folder is properly excluded from the resulting archive:

```bash
tar -ztvf ~/backup/backup_home_${USER}_*.tar.gz | grep "backup/"
```

If the command returns no results, the exclusion works as intended.
