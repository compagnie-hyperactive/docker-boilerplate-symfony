# Ready-To-Start LAMP stack with Symfony and PHPMyAdmin
This boilerplate is a ready-to-start customizable LAMP stack with Symfony and PHPMyAdmin integration. 
__Warning : for Linux/Mac users only__.

## Installation

Use Composer to initiate project.

```
composer create-project devgiants/docker-symfony target-dir 0.1.6
```

## Configuration
### Custom parameters

#### .env file
First of all, specify parameters needed for the project

##### Directories
- __RELATIVE_APP_PATH__: This is the relative path from project initial path. Default to `./`. _Note: a volume will be created on this path in order to persist Symfony app files_. 
- __LOGS_DIR__: The logs directory.

##### Host
- __HOST_USER__: Your current username. Needed to ensure creation (directories...) with your current user to preserve mapping between container and host
- __HOST_UID__: Your current user host ID (uid). This is mandatory to map the UID between PHP container and host, in order to let you edit files both in container an through host volume access.
- __HOST_GID__: Your current main group host ID (gid). (Not used so far)

##### Project
- __PROJECT_NAME__: The project name.

##### Database
- __MYSQL_HOST__: The database host. Has to be equal to database container name in `docker-compose.yml` file (default `mysql`).    
- __MYSQL_DATABASE__: The database name you want
- __MYSQL_USER__: user that will be created on image creation
- __MYSQL_PASSWORD__: the database password you want for above user
- __MYSQL_HOST_PORT__: the port you want to be able to reach the MySQL server (from the host) on. 
- __MYSQL_PORT__: the MySQL instance port. Careful, this is the MySQL port __in container__. Default to `3306`  
- __MYSQL_HOST_VOLUME_PATH__: default `./data/mysql/5.7`. This is the volume which will store database.

##### Ports    

You can have multiple projects using this boilerplate, but without changing ports, only one project can be up at a time.

- __APPLICATION_WEB_PORT__: default to `8800`.
- __PHP_MY_ADMIN_PORT__: default to `8801`.


## Usage
There are 2 ways to use this : __initialisation__ and __day-to-day usage__.
### Initialisation
You have to run `make install-symfony`. This script will 
1. execute the `composer create-project` command for installing Symfony
2. Copy the `.env` content from Symfony app to existing `.env`.
3. Copy the `.gitignore` content from Symfony app to existing `.gitignore`.

_Note : once `.env` updated, after Symfony install, you have to edit the elements added to make them use predefined variables (for example MySQL connection URL)._

### Day-to-day usage
Then, on day-to-day usage, just run 
- `make up` to make system live
- `make down` to shutdown this project with containers removal. 

_Note : All volumes set will ensure to persist both app files and database._

## `Makefile` commands available

### `assets-install`
Execute Symfony `assets:install --symlink` command.
### `bash-php`
Gives a shell in php container with www-data user.
### `bash-php-root`
Gives a shell in php container with root user.
### `build`
Build the containers. To be used to force containers recreation.
### `cache-clear`
Execute Symfony cache clear command.
### `composer-install`
Execute `composer install`.
### `dsu-dump`
This runs a `doctrine:schema:update --dump-sql`.
### `dsu-force`
This runs a `doctrine:schema:update --force`.
### `down`
Down the containers.
### `encore-dev`
Make an Encore assets generation (dev mode).
### `encore-prod`
Make an Encore assets generation (prod mode).
### `encore-watch`
Make an Encore assets generation (watch mode).
### `fixtures-load`
This runs a `doctrine:fixtures:load`.
### `install-symfony`
Install Symfony as described above. Will also install the Maker and Migrations bundle. 
### `install-app`
Execute all steps to install your app on top of Symfony installation. This commands executes :
1. `build` command.
2. `composer-install` command.
3. `composer-install` command.
4. `migrate` command.
5. Configure `Yarn` cache and global folder.
6. Install NPM packages.
7. Run a production assets generation.
### `make-migration`
This runs a `make:migration`.
### `migrate`
This runs a `doctrine:migrations:migrate`.
### `up`
Makes system live. Also substitute `www-data` UID with given UID to avoid write permissions problems.

### PhpMyAdmin
Accessible on `localhost:8801` by default. Use `MYSQL_USER` and `MYSQL_PASSWORD` to connect.
