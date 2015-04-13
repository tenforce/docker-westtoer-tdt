#!/bin/bash

# Make feeds folder accessible to TDT
chown -R www-data:www-data /home/datahub/feeds/
chmod 2755 -R /home/datahub/feeds/

# Link TDT public folder
mkdir -p /home/datahub/apps/default
rm /home/datahub/apps/default/public 2>/dev/null
ln -s /app/tdt-core/public /home/datahub/apps/default/

# Link external folder in TDT public folder
rm /app/tdt-core/public/ext 2>/dev/null
ln -s /app/datahub-config/ext /app/tdt-core/public

# Make Snorql app available
rm /app/snorql 2>/dev/null
ln -s /app/tdt-core/public/snorql /app

# Make htaccess-ext availabe to TDT
chown www-data:www-data /home/datahub/htaccess-ext

# Restrict access to htpasswd
chmod 644 /home/datahub/feeds/.htpasswd

# Link mappings and crons
mkdir -p /home/datahub/live
rm /home/datahub/live/mappings 2>/dev/null
ln -s /app/datahub-config/datatank/mappings /home/datahub/live/
rm /home/datahub/live/crons 2>/dev/null
ln -s /app/datahub-config/ETL/crons /home/datahub/live/

# Make cron jobs executable
cd /home/datahub/live/crons
chmod +x *.sh

# Install crontab file of the datahub user
su - datahub -c "crontab /home/datahub/live/crons/crons.conf"

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
