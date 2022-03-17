#!/bin/bash
# specify the repository to use for wordpress backups
export BORG_REPO='ssh://HOST:PORT/./wordpress_html'

# Stop the container
/usr/bin/docker-compose -f /opt/wordpress/docker-compose.yml down

# Run wordpress Borg backup
/usr/bin/borg create --stats ::$(hostname)-$(date -I) /var/lib/docker/volumes/wordpress_html/

# Prune old wordpress backups
/usr/bin/borg prune -v --list --keep-daily 7 --keep-weekly 1

# Change Repo to databsase
export BORG_REPO='ssh://HOST:PORT/./wordpress_db'

# Run database Borg Backup
/usr/bin/borg create --stats ::$(hostname)-$(date -I) /var/lib/docker/volumes/wordpress_db/

# Prune old database backups
/usr/bin/borg prune -v --list --keep-daily 7 --keep-weekly 1

# Start the container back up
/usr/bin/docker-compose -f /opt/wordpress/docker-compose.yml up -d

# If you use a .env file with your docker-compose.yml you will need to specify the working directory with --project-directory /path/to/env/
# Example: /usr/bin/docker-compose -f /opt/wordpress/docker-compose.yml --project-directory /path/to/env/ down