# Science TrotterS docker backend Infra

## check the submodules

The Docker will host code from :
- the API : https://github.com/medialab/ScienceTrotterS_API
- the backoffice : https://github.com/medialab/ScienceTrotterS_backoffice
- the mobile app : https://github.com/medialab/ScienceTrotterS_mobile

```bash
git submodule status
```

## Configuration

This application exposes three ports : 

- the backoffice (default to 8080)
- the mobile app as web static app (default to 8081)
- the API port (default to 5000) used by the mobile application. This port could stay private by adding a reverse proxy in the nginx mobile_app configuration in ./mobile_app.conf

Exposed port are defined in docker_compose.yml  
The API public URL must be specified in mobile_app.dockerfile env variable before building the container.

## Build specific containers

### phpcomposer

A PHP 7 container in which we add php-composer
```bash
docker build --build-arg DEVMODE=true -t phpcomposer -f phpcomposer.dockerfile .
```

### mobile_app

A nginx container in which we add a nodejs context to build the mobile app as a static web app.  
Nodejs and dependencies are removed.

```bash
docker build -t mobile_app -f mobile_app.dockerfile .
```

## Start the containers

```bash
docker-compose up
```

## Setup the php environnement and database initialisation

To be done only once when the docker services are running to install PHP dependencies and to hydrate the database with some test data.

```bash
./setup_php_db.sh
```

# TO DO 

- add SSL conf to API nginx
- move composer isntall to Dockerfile
- add a database backup volume
- add an upload volume
- ~~add host and port conf in env variables in submodules~~
- ~~add admin password in configuration~~
- ~~limit submodules to depth = 1~~
