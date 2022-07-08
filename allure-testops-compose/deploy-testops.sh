#!/bin/bash

apt update && apt upgrade -y && apt install docker.io -y
export DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

git clone https://github.com/qameta/allure-docker-compose.git && \
mkdir ~/allure-testops && \
cp ${PWD}/allure-docker-compose/docker-compose.yml ~/allure-testops && \
cp ${PWD}/allure-docker-compose/env-example ~/allure-testops/.env && \
cp -r ${PWD}/allure-docker-compose/configs ~/allure-testops/ && \
cd ~/allure-testops

docker compose pull && docker compose up -d && docker compose logs -f 