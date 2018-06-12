# Science TrotterS docker backend Infra

## update the sumodules

The Docker will host code from :
- the API : https://github.com/medialab/ScienceTrotterS_API
- the backoffice : https://github.com/medialab/ScienceTrotterS_backoffice

```bash
git submodule update
```

## Build the PHP container

```bash
docker build -t phpcomposer .
```

## Start the containers

```bash
docker-compose up
```

## Setup the php environnement and database initialisation

To be done only once to install PHP depedencies and to hydrate the database with some test data.

```bash
./setup_php_db.sh
```

# TO DO 

- add SSL conf to API nginx
- ~~add host and port conf in env variables in submodules~~
- ~~add admin password in configuration~~
- limit submodules to depth = 1
- move composer isntall to Dockerfile
- add a database backup volume
- add an upload volume