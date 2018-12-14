#!make
include .env
export $(shell sed 's/=.*//' .env)

bash-php: up
	#ifeq ($(user))
	#user := 'www-data'

	docker-compose exec -u $(user) php bash

install: up

database-create: up

up:
	docker-compose up -d

down:
	docker-compose down
