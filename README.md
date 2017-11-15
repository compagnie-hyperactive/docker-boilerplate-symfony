# Ready-To-Start LAMP stack with Symfony and PHPMyAdmin
This boilerplate is a ready-to-start customizable LAMP stack with Symfony and PHPMyAdmin integration. 
__Warning : for Linux users only__.

## Installation
So far, just __download archive__ and __extract it__ in the __target project directory__ (i.e `/home/your_user/my_project`).

## Configuration
### Custom parameters

#### .env file
First of all, specify parameters needed for the project

##### Directories
- __SYMFONY_HOST_RELATIVE_APP_PATH__: This is the relative path from project initial path. Default to `./symfony`. _Note: a volume will be created on this path in order to persist Symfony app files_. 
- __LOGS_DIR__: The logs directory.

##### Host
- __HOST_USER__: Your current username. Needed to ensure creation (directories...) with your current user to preserve mapping between container and host
- __HOST_UID__: Your current user host ID (uid). This is mandatory to map the UID between PHP container and host, in order to let you edit files both in container an through host volume access.
- __HOST_GID__: Your current main group host ID (gid). (Not used so far)

##### Project
- __PROJECT_NAME__: The project name.

##### Database
- __MYSQL_HOST__: The database host. Has to be equal to database container name in `docker-compose.yml` file (default `mysql`).    
- __MYSQL_DB__: The database name you want
- __MYSQL_USER__: root (not used so far, assuming root connecition on dev stage)
- __MYSQL_ROOT_PASSWORD__: the database password you want 
- __MYSQL_PORT__: the MySQL instance port. Careful, this is the MySQL port __in container__. Default to `3306`  
- __MYSQL_HOST_VOLUME_PATH__: default `./docker/mysql/5.7`. This is the volume which will store database.

##### Ports    

You can have multiple projects using this boilerplate, but without changing ports, only one project can be up at a time, because port 80 is used to expose Apache.

- __APPLICATION_WEB_PORT__: default to `80`.
- __PHP_MY_ADMIN_PORT__: default to `81`.

##### Symfony specifics    
- __SECRET__: replace this salt __each time__.

#### Specific Symfony parameters
If you have any parameters you want to add before first start, add them in `parameters.yml.dist` located on root. It will be used below.

## Usage
There are 2 ways to use this : __initialisation__ and __day-to-day usage__.
### Initialisation
You have to run `bash init.sh`. This script will :
1. Run Symfony installer to install Symfony in `SYMFONY_HOST_RELATIVE_APP_PATH`. So far, it takes the latest version available. _Note: if `symfony` installer not present, the script will download it and install it._
2. Copy `.env` and `parameters.yml.dist` files in new installation. The first is to make environment variables available in `config.yml`, second is to force using this variables to create `parameters.yml`.
3. Run `docker-compose` to create container and make system live. _Note: if `docker-compose` is not present, the script will download it and install it._
4. Remove initial `parameters.yml` to force composer update to recreate one.
5. Run `composer update --no-interaction` to update vendors.

### Day-to-day usage
Then, on day-to-day usage, just run 
- `docker-compose up` to make system live
- `docker-compose stop` to shutdown this project without removing containers. 

_Note : Once you have stop one project, you can up another one safely._

_Note : All volumes set will ensure to persist both app files and database._

### Reset from scratch
If you want to reset everything, just
1. Run `docker-compose down` 
2. Remove the __SYMFONY_HOST_RELATIVE_APP_PATH__ and the __MYSQL_HOST_VOLUME_PATH__
3. Then goes back on `bash init.sh`

### Symfony
Accessible on `localhost` by default.

Important note : to execute console, __be sure to connect to php container with www-data user__. The mapping described above targets www-data on container.
Command to use : `docker-compose exec -u www-data php bash`

### PhpMyAdmin
Accessible on `localhost:81` by default. Use `MYSQL_USER` and `MYSQL_ROOT_PASSWORD` to connect.