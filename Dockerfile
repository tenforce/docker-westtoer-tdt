FROM tutum/apache-php

RUN apt-get update \
      && apt-get install -y git apt-utils memcached curl php5-memcache php5-mcrypt php5-mysql php5-curl cron \
      && a2enmod rewrite \
      && php5enmod mcrypt

# Update the apache sites available with the datatank config
ADD apache-config.conf /etc/apache2/sites-available/000-default.conf

# Add new datahub user with a home folder and sudo privileges
RUN groupadd -r datahub && useradd -r -m -g datahub datahub && adduser datahub sudo \
      && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Add the ext .htaccess file
ADD htaccess-ext /home/datahub/htaccess-ext

ADD startup.sh /
CMD ["/bin/bash", "/startup.sh"]