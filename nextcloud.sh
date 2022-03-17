#!/bin/bash
# specify the nextcloud data repository to use for backups
export BORG_REPO='ssh://HOST:PORT/./nextcloud_data'

# Switch Nextcloud into maintenance mode
/usr/bin/docker exec -it -u www-data nextcloud php occ maintenance:mode --on

# Wait 1 minutes for any synchronisation to finish
sleep 60

# Stop the container
/usr/bin/docker-compose -f /opt/nextcloud/docker-compose.yml --project-directory /opt/nextcloud/ down

# Run nextcloud_data Borg backup
/usr/bin/borg create --stats ::$(hostname)-$(date -I) /var/lib/docker/volumes/nextcloud__data/

# Prune old nextcloud_data backups
/usr/bin/borg prune -v --list --keep-daily 7 --keep-weekly 1

# Change Repo to nextcloud_html
export BORG_REPO='ssh://HOST:PORT/./nextcloud_html'

# Run nextcloud_html Borg backup
/usr/bin/borg create --stats ::$(hostname)-$(date -I) /var/lib/docker/volumes/nextcloud__html/

# Prune old nextcloud_html backups
/usr/bin/borg prune -v --list --keep-daily 7 --keep-weekly 1

# Change Repo to nextloud_database
export BORG_REPO='ssh://HOST:PORT/./nextcloud_mariadb'

# Run nextcloud_database Borg Backup
/usr/bin/borg create --stats ::$(hostname)-$(date -I) /var/lib/docker/volumes/nextcloud__mariadb/

# Prune old nextcloud_database backups
/usr/bin/borg prune -v --list --keep-daily 7 --keep-weekly 1

# Start the container back up
/usr/bin/docker-compose -f /opt/nextcloud/docker-compose.yml --project-directory /opt/nextcloud/ up -d

# Disable Nextcloud maintenance mode
/usr/bin/docker exec -it -u www-data nextcloud php occ maintenance:mode --off