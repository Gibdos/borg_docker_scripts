## BorgBackup Websites
- [Official Website](https://www.borgbackup.org/)
- [Docs](https://borgbackup.readthedocs.io/en/stable/)

## Repo Init
```bash
# initialize repository
borg init --encyption repokey-blake2 user@hostname:port/path/to/repo

# export repokey for backup
borg key export username@hostname:port/path/to/repo /path-to-keyfile/filename
```

## backup via .sh
```bash
#!/bin/bash
# specify the default repository to use for backups via ENV
export BORG_REPO='ssh://<user>@<hostname>:<port>/path/to/repo'

# Run Borg backup
/usr/bin/borg create --stats ::$(hostname)-$(date -I) /path/to/source/

# Prune old backups
/usr/bin/borg prune -v --list --keep-daily 7 --keep-weekly 1
```

## Docker Volumes Backup

### Nextcloud
```bash
#!/bin/bash
# specify the default repository to use for backups
export BORG_REPO='ssh://<user>@<hostname>:<port>/nextcloud_data'

# Switch Nextcloud into maintenance mode
/usr/bin/docker exec -it -u www-data nextcloud php occ maintenance:mode --on

# Wait 5 minutes for any remaining work to finish
sleep 300

# Stop the container
/usr/bin/docker-compose -f /opt/nextcloud/docker-compose.yml --project-directory /opt/nextcloud/ down

# Run nextcloud_data backup
/usr/bin/borg create --stats ::$(hostname)-$(date -I) /var/lib/docker/volumes/nextcloud__data/

# Prune old nextcloud_data backups
/usr/bin/borg prune -v --list --keep-daily 7 --keep-weekly 1

# Change Repo to nextcloud_html
export BORG_REPO='ssh://<user>@<hostname>:<port>/nextcloud_html'

# Run nextcloud_html backup
/usr/bin/borg create --stats ::$(hostname)-$(date -I) /var/lib/docker/volumes/nextcloud__html/

# Prune old nextcloud_html backups
/usr/bin/borg prune -v --list --keep-daily 7 --keep-weekly 1

# Change Repo to nextcloud_database
export BORG_REPO='ssh://<user>@<hostname>:<port>/nextcloud_mariadb'

# Run nextcloud_database backup
/usr/bin/borg create --stats ::$(hostname)-$(date -I) /var/lib/docker/volumes/nextcloud__mariadb/

# Prune old nextcloud_database backups
/usr/bin/borg prune -v --list --keep-daily 7 --keep-weekly 1

# Start the container back up
/usr/bin/docker-compose -f /opt/nextcloud/docker-compose.yml --project-directory /opt/nextcloud/ up -d

# Disable Nextcloud maintenance mode
/usr/bin/docker exec -it -u www-data nextcloud php occ maintenance:mode --off

########################################################################################################################
# When working with .env you will need to specify the working directory with --project-directory /path-to-working-dir/ #
########################################################################################################################
```

### MailCow Dockerized
```bash
#!/bin/bash
# Specify the MailCow backUp location
export MAILCOW_BACKUP_LOCATION='/opt/mailcow-backup'

# Run the MailCow backup helper script
/opt/mailcow-dockerized/helper-scripts/backup_and_restore.sh backup all --delete-days 1

# Specify the default repository to use for backups
export BORG_REPO='ssh://<user>@<hostname>:<port>/mailcow'

# Run Borg backup
/usr/bin/borg create --stats ::$(hostname)-$(date -I) /opt/mailcow-backup/

# Prune old backups
/usr/bin/borg prune -v --list --keep-daily 7 --keep-weekly 1
```

### Wordpress incl. Database
```bash
#!/bin/bash
# specify the default repository to use for backups
export BORG_REPO='ssh://<user>@<hostname>:<port>/wordpress_data'

# Stop the container
/usr/bin/docker-compose -f /opt/wordpress/docker-compose.yml down

# Run wordpress_data backup
/usr/bin/borg create --stats ::$(hostname)-$(date -I) /var/lib/docker/volumes/wordpress_data/

# Prune old wordpress_data backups
/usr/bin/borg prune -v --list --keep-daily 7 --keep-weekly 1

# Change Repo to wordpress_database
export BORG_REPO='ssh://<user>@<hostname>:<port>/wordpress_db'

# Run wordpress_database backup
/usr/bin/borg create --stats ::$(hostname)-$(date -I) /var/lib/docker/volumes/wordpress_db/

# Prune old wordpress_database backups
/usr/bin/borg prune -v --list --keep-daily 7 --keep-weekly 1

# Start the container back up
/usr/bin/docker-compose -f /opt/wordpress/docker-compose.yml up -d

########################################################################################################################
# When working with .env you will need to specify the working directory with --project-directory /path-to-working-dir/ #
########################################################################################################################
```
