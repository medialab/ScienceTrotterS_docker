#!/bin/bash
echo 'installing depedencies'
docker-compose exec php composer install;
echo 'init database...'
docker-compose exec php php init_database.php;
echo 'update database...'
docker-compose exec php php update_database.php;
echo 'done'