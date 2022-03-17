#!/bin/bash
# Specify the MailCow backUp location
export MAILCOW_BACKUP_LOCATION='/opt/mailcow-backup'

# Run the MailCow backup helper script
/opt/mailcow-dockerized/helper-scripts/backup_and_restore.sh backup all --delete-days 1

# specify the default repository to use for backups
export BORG_REPO='ssh://HOST:PORT/./mailcow'

# Run Borg backup
/usr/bin/borg create --stats ::$(hostname)-$(date -I) /opt/mailcow-backup/

# Prune old backups
/usr/bin/borg prune -v --list --keep-daily 7 --keep-weekly 1