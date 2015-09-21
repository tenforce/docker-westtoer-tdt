# Westtoer Datatank docker
Docker for Westtoer Datatank application

## Running The Datatank
    docker run --name my-datatank \
        -p 80:80 \
        --link my-mysql:mysql \
        --link my-virtuoso:virtuoso \
        --volume /path/to/datatank/application:/app/tdt-core \
        --volume /path/to/datahub-config:/app/datahub-config \
        --volume /path/to/external/feeds/:/home/datahub/feeds \
        --volume /path/to/external/ttl/:/home/datahub/ttl \
        -h data.mytank.com \
        -e GITHUB_TOKEN=myGitHubToken \
        -d tenforce/westtoer-tdt

The GitHub token is used to download PHP dependencies from GitHub via Composer.

The hostname is the public hostname via which the Datatank application will be accessed.

The MySQL connection must be correctly configured in `/path/to/datatank/application/app/config/database.php`. The user and database must already be created.

The SPARQL endpoint must be correctly configured in `/path/to/datatank/application/public/snorql/sparql.php`

The cronjobs folder must contain `crons.conf` which will be installed as crontab file.

The feeds folder must contain an `.htpasswd` file.

## Executing Laravel CLI tasks
Enter The Datatank docker, go to The Datatank application folder and run the task (e.g. migrations)

    docker exec -it my-datatank bash
    cd /app/tdt-core
    php artisan migrate

To get an overview of all available tasks, run:

    php artisan --list
    
