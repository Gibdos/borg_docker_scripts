#!/bin/bash
# specify the default repository to use for backups
export BORG_REPO='ssh://HOST:PORT/./docker-compose'

# Run Borg backup
/usr/bin/borg create --stats ::$(hostname)-$(date -I) /opt/

# Prune old backups
/usr/bin/borg prune -v --list --keep-daily 7 --keep-weekly 1