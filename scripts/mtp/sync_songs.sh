#!/bin/bash

# ============================
# PATHS
# ============================
PC_DIR="$HOME/Downloads/Songs"
PHONE_DIR="$HOME/mtp/Internal storage/Download/Songs/"
LOGFILE="$HOME/.cache/song_sync.log"

# ============================
# COLORS
# ============================
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
RESET="\033[0m"

VERIFY=false
WORKERS=4   # parallel copy workers

# ============================
# Parse args
# ============================
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --verify) VERIFY=true ;;
        --workers)
            WORKERS="$2"
            shift
            ;;
        --dry-run) DRYRUN="--dry-run" ;;
        *) echo -e "${RED}Unknown option: $1${RESET}" ; exit 1 ;;
    esac
    shift
done

DATE=$(date +"%Y-%m-%d %H:%M:%S")
echo -e "${BLUE}▶ Starting rsync sync...${RESET}"
echo "======== SYNC START: $DATE ========" >> "$LOGFILE"

echo -e "${YELLOW}PC:    $PC_DIR${RESET}"
echo -e "${YELLOW}Phone: $PHONE_DIR${RESET}"

if [ ! -d "$PC_DIR" ]; then
    echo -e "${RED}[ERR] PC directory missing: $PC_DIR${RESET}"
    exit 1
fi

if [ ! -d "$PHONE_DIR" ]; then
    echo -e "${RED}[ERR] Phone directory missing: $PHONE_DIR${RESET}"
    exit 1
fi

# ============================
# Primitive MTP mount check
# ============================
if ! mount | grep -qi "jmtpfs"; then
    echo -e "${RED}[ERR] No MTP (jmtpfs) mount detected.${RESET}"
    echo -e "${YELLOW}Hint:${RESET} jmtpfs \"$HOME/mtp\""
    exit 1
fi

# folder exists but might be empty (ghost mount)
if [ -z "$(ls -A "$HOME/mtp/")" ]; then
    echo -e "${RED}[ERR] MTP mountpoint exists but is empty — not mounted properly.${RESET}"
    exit 1
fi

OPTS=(
    -avh
    --info=progress2
    --itemize-changes
    --ignore-existing
    --human-readable
    --log-file="$LOGFILE"
    --no-perms --no-owner --no-group
    --exclude=".*"
)

# parallel copy
OPTS+=( --blocking-io )

if $VERIFY; then
    # verify by checksum (SLOW, safer)
    OPTS+=( --checksum )
fi

if [ "$WORKERS" -gt 1 ]; then
    # rsync 3.2+ supports parallelism with --info=progress2 better
    export RSYNC_NUM_WORKERS="$WORKERS"
fi

echo -e "${BLUE}▶ Running rsync (workers: $WORKERS, verify: $VERIFY)...${RESET}"

rsync "${OPTS[@]}" $DRYRUN \
    "$PC_DIR"/ \
    "$PHONE_DIR"/

STATUS=$?

if [ $STATUS -eq 0 ]; then
    echo -e "${GREEN}✔ Sync completed successfully.${RESET}"
else
    echo -e "${RED}✖ Sync completed with errors. Check log: $LOGFILE${RESET}"
fi

echo "======== SYNC END ========" >> "$LOGFILE"
