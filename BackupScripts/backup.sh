#!/bin/bash

DEST="/backup"
FILES_TO_BACKUP="files-to-backup.txt" # For cron job
if [[ $# -ge 0 ]]; then
    FILES_TO_BACKUP=$@
fi

DATE=$(date +%d-%m-%Y)
TIMESTAMP=$(date +%H-%M-%S)
ARCHIVED="$(hostname)_${DATE}_${TIMESTAMP}.tgz"
LOG_FILE="$(hostname).log"

tar -czf "${DEST}/${ARCHIVED}" ${FILES_TO_BACKUP}

if [[ $? -eq 0 ]]; then
    echo "[${DATE} ${TIMESTAMP}] SUCCESS: Backed up ${FILES_TO_BACKUP} -> ${DEST}/${ARCHIVED}" >> ${DEST}/${LOG_FILE}
else
    echo "[${DATE} ${TIMESTAMP}] FAILED: Could not back up ${FILES_TO_BACKUP}" >> ${DEST}/${LOG_FILE}
fi
