#!/bin/bash

# Remove Tutum files
rm /app/index.php
rm /app/logo.png

# Remove old symbolic links
rm /home/datahub/apps/default/public 2>/dev/null
rm /app/tdt-core/public/ext/feeds 2>/dev/null
rm /app/tdt-core/public/ext/ttl 2>/dev/null
rm /app/tdt-core/public/ext 2>/dev/null
rm /home/datahub/live/crons 2>/dev/null
rm /home/datahub/live/scripts 2>/dev/null

# Make feeds folder accessible to TDT
chown -R datahub:datahub /home/datahub/feeds/
chmod 2777 -R /home/datahub/feeds/

# Link TDT public folder to Apache root config
mkdir -p /home/datahub/apps/default
ln -s /app/tdt-core/public /home/datahub/apps/default/

# Link external folder in TDT public folder
ln -s /app/datahub-config/ext /app/tdt-core/public

# Link feeds folder in TDT public/ext folder
ln -s /home/datahub/feeds /app/tdt-core/public/ext/

# Link ttl folder in TDT public/ext folder
ln -s /home/datahub/ttl /app/tdt-core/public/ext/

# Make .htaccess of the ext folder availabe to TDT
chown www-data:www-data /app/datahub-config/ext/.htaccess

# Restrict access to htpasswd
chmod 644 /home/datahub/feeds/.htpasswd

# Link cron jobs and scripts folder
mkdir -p /home/datahub/live
ln -s /app/datahub-config/crons /home/datahub/live/
ln -s /app/datahub-config/scripts /home/datahub/live/

# Make scripts and cron jobs executable
cd /home/datahub/live/scripts
chmod +x *.sh
cd /home/datahub/live/crons
chmod +x *.sh

# Install crontab file of the datahub user
crontab -u datahub /home/datahub/live/crons/crons.conf

# Datatank installation
cd /app/tdt-core
composer config -g github-oauth.github.com $GITHUB_TOKEN
composer install --no-scripts

# Add permissions to the log and storage directory
chmod -R 777 /app/tdt-core/app/storage/

# Start cron in the background
# cron -f &

# Start apache
source /etc/apache2/envvars
tail -Fq /var/log/apache2/* &
exec apachectl -e info -D FOREGROUND
