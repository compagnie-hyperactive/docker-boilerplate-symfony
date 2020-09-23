#!make
include .env
export $(shell sed 's/=.*//' .env)

# Provides a bash in PHP container (user www-data)
bash-php: up
	docker-compose exec -u www-data php bash

# Provides a bash in PHP container (user root)
bash-php-root: up
	docker-compose exec php bash


install-symfony: build
	# Create skeleton using last version available
	docker-compose exec -u www-data php composer create-project symfony/website-skeleton ${RELATIVE_APP_PATH}/tmp

	# append SF .env file to stack .env
	cat "${RELATIVE_APP_PATH}/tmp/.env" >> .env

	# append SF .env file to stack .env
	cat "${RELATIVE_APP_PATH}/tmp/.gitignore" >> .gitignore

	# remove tmp/.env and /tmp/.gitignore file now its content is appended
	rm ${RELATIVE_APP_PATH}/tmp/.env ${RELATIVE_APP_PATH}/tmp/.gitignore

	# remove vendor folder as it will be replaced by Symfony one
	rm -rf vendor

	# move all app up
	mv ${RELATIVE_APP_PATH}/tmp/* ${RELATIVE_APP_PATH}
	mv ${RELATIVE_APP_PATH}/tmp/.env.test ${RELATIVE_APP_PATH}

	# rm tmp folder
	rm -r ${RELATIVE_APP_PATH}/tmp

	# Install migrations
	docker-compose exec -u www-data php composer require doctrine/doctrine-migrations-bundle

	# Install dev helpers maker
	docker-compose exec -u www-data php composer require symfony/maker-bundle --dev
	docker-compose exec -u www-data php composer require phpstan/phpstan --dev

# Build app
install-app: build composer-install migrate

	# Configure Yarn storage
	docker-compose exec -u www-data php yarn config set global-folder ${YARN_GLOBAL_FOLDER}
	docker-compose exec -u www-data php yarn config set cache-folder ${YARN_CACHE_FOLDER}

	# Install $Yarn dependencies
	docker-compose exec -u www-data php yarn install

	# Compile application assets
	docker-compose exec -u www-data php yarn encore production

composer-install: up
	# Install PHP dependencies
	docker-compose exec -u www-data php composer install

# Build front assets in dev mode (no minifying...)
encore-dev: up
	docker-compose exec -u www-data php yarn encore dev

# Build front assets in prod mode (minifying...)
encore-prod: up
	docker-compose exec -u www-data php yarn encore production

# Start Encore in watch mode, re-compiling on each change
encore-watch: up
	docker-compose exec -u www-data php yarn encore dev --watch

dsu-dump: up
	docker-compose exec -u www-data php php bin/console doctrine:schema:update --dump-sql

dsu-force: up
	docker-compose exec -u www-data php php bin/console doctrine:schema:update --force

# Migrate database with differences
migrate: up
	docker-compose exec -u www-data php php bin/console doctrine:migrations:migrate

make-migration: up
	docker-compose exec -u www-data php php bin/console make:migration

assets-install: up
	docker-compose exec -u www-data php php bin/console assets:install --symlink

cache-clear: up
	docker-compose exec -u www-data php php bin/console cac:c

fixtures-load: up
	docker-compose exec -u www-data php php bin/console doctrine:fixtures:load

# Up containers
up:
	docker-compose up -d
	docker-compose exec php usermod -u ${HOST_UID} www-data
	docker-compose exec apache usermod -u ${HOST_UID} www-data

# Up containers, with build forced
build:
	docker-compose up -d --build
	docker-compose exec php usermod -u ${HOST_UID} www-data
	docker-compose exec apache usermod -u ${HOST_UID} www-data

# Down containers
down:
	docker-compose down
