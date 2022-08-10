# Grafana with PostgreSQL

[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fbeerjoa%2Fmonitoring-grafana-postgresql&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)

This repository can build a Grafana service easily and quickly using Docker.

## Features
* [Grafana](https://grafana.com/docs/)
   > open-source platform for monitoring and observability
* [Grafana image renderer](https://grafana.com/grafana/plugins/grafana-image-renderer/)
   > Grafana backend plugin that handles rendering panels and dashboards to PNGs using a headless browser (Chromium).
* [PostfreSQL](https://www.postgresql.org/docs/)
   > open-source relational database management system. \
     using it as a [*Grafana metadata database*](https://grafana.com/docs/grafana/next/setup-grafana/configure-grafana/#database)


## Requirements
* [Docker](https://docs.docker.com/engine/install/)
* [Docker Compose](https://docs.docker.com/compose/install/)

## Installation
docker install script only for Linux OS (Ubuntu/CentOs)
```bash
# Install docker
$ sudo chmod 755 ./install-docker.sh
$ sudo ./install-docker.sh
```

## Build
Setting Environments and Build Docker volumes for Grafana stack
```bash
# .env file
$ mv .env.example .env

# Create docker volume & network and Set directory owner & mode
$ make build
``` 

## Usage
By default, simply run as `make run` command.
```bash
# it means, `docker compose up`
$ make run
``` 
If you want to change `run` command, fix it in Makefile.
```bash
# fix `run` in Makefile.
# @docker compose --env-file ./.env -f ./workspace/grafana/docker-compose.yml up [SERVICE...]
$ make run
``` 

## Configuraion
* .env: related to `Makefile` and `workspace/grafana/docker-compose.yml`
```bash
# .env

# docker volume path
DEFAULT_CONTAINER_VOLUME_PATH=/data/container

# docker volume
VOLUME_GRAFANA_DATA=grafana_data
VOLUME_GRAFANA_PROVISIONING=grafana_provisioning
VOLUME_POSTGRESQL_DATA=postgresql_data_grafana

# docker network
NETWORK_GRAFANA=grafana-net

# version for official docker images
IMAGE_GRAFANA=8.5.4
IMAGE_GRAFANA_IMAGE_RENDERER=3.4.1
IMAGE_POSTGRESQL=12.2-alpine
```

If you want to know about `Grafana` and `PosgreSQL` configuraion , [here](https://github.com/beerjoa/monitoring-grafana-postgresql/blob/main/workspace/grafana/README.md)

## Structure
```bash
└── monitoring-grafana-postgresql
   ├── install-docker.sh            # Install docker
   ├── README.md
   ├── Makefile                     # Build & Run script
   ├── LICENSE.md
   └── workspace
      └── grafana                   # Grafana workspace
         ├── docker-compose.yml     # related to `.env` and `Makefile`
         ├── README.md              # README for Grafana workspace
         ├── postgresql             # postgresql init directory
         └── grafana                # grafana init directory
```
