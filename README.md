# docker-lemp

## Background & objective

Manual porting development env is troublesome. Docker is solving the problem by automating these steps.

So here is the collection of Dockerising LEMP stack env.

Here aredevelopment and production environment for PHP built in seperate docker containers, managed with docker-compose.
The basic setup contains a LEMP stack (Linux, Nginx, MySQL and PHP) 

Most importantly, the idea behind would be CODE + DATA will be persistently saved.
Docker container will be runtime env which can be up and down freely.

## Package Details
 * Nginx
 * PHP 7.0 contain:
    * APCu (optional)
    * XDebug (optional)
    * Mailcatcher (optional)
    * Production/development config (optional)
    * Wkhtmltopdf
    * Wkhtmltoimage
    * Composer
    * PHPUnit
    * Phing/Ant
    * ...
 * MariaDB

## Specifying development or production use

Currently there are a few changes that are supported through config files and mounted files.

The container support 4 environment variables that can be filled through your compose configuration file:

    # Set this to `true` to enable APCu cache, and to `false` to disable it.
    PHP_APCU_ENABLED: 'false'
    # Set this to `true` to enable XDebug, and to `false` to disable it. Typically enabled only for development
    PHP_XDEBUG_ENABLED: 'true'
    # Set this to `true` to enable mailcatcher, and to `false` to disable it. Typically enabled only for development
    PHP_MAILCATCHER_ENABLED: 'true'
    # Set this to `development` to load the mounted development.ini file, and to `production` to load the mounted production.ini file.
    PHP_ENV: 'development'

When disabling mailcatcher you can remove the mailcatcher service in your compose file, with the links to the mailcatcher service from other services as well (like in the production compose configuration file).

## Launching containers

You can specify the configuration file with the `-f` flag, which will result in:

    docker-compose -f development.yml up
    
OR

    docker-compose -f production.yml up

## More detail command line

    # Start development environment. Will recreate linked containers of new services, using compose-up-development.yml
    up_dev
    # The same as up_dev but then for your production environment, using compose-up-production.yml
    up_prod
    # Create a backup of the MariaDB instance in data/backups/
    backup_database
    # Create a backup of the wwwdata container volum in data/backups/
    backup_www
    # Reload PHP FPM of the php70 service
    reload_php_70:
    # Reload the nginx configuration files (service nginx reload)
    reload_nginx:
	
	# Connect to different containers. (Create a bash shell session inside a container)
	connect_mailcatcher
	connect_mariadb
	connect_nginx
	connect_php70
	connect_wwwdata

Commands for building and developing the services:

    # Stop and remove all containers shown by 'docker ps -a'
    clear_containers
    # Remove all stored images shown by 'docker images'
    clear_images
    # Will run both 'clear_containers' and 'clear_images"
    clear_all
    # Use the compose build file to build all containers, even unused containers for specific environments
    build

