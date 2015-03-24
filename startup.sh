#!/bin/bash

# Make feeds folder accessible to Datatank application
chmod -R 777 /home/datahub/feeds/

# Make cron jobs executable
cd /home/datahub/live/crons
chmod +x *.sh

# Install crontab file
crontab /home/datahub/live/crons/crons.conf

# Datatank installation
cd /app/tdt-core
composer config -g github-oauth.github.com $GITHUB_TOKEN
composer install --no-scripts

# Add permissions to the log and storage directory
chmod -R 777 /app/tdt-core/app/storage/

# Start cron in the background
cron -f &

# Restart apache
service apache2 restart

tail -f /var/log/apache2/error.log
