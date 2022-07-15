#!/bin/bash

cd ~
apt update && apt upgrade -y
apt install docker.io -y
export DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins || true
curl -SL https://github.com/docker/compose/releases/download/v2.6.0/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose || true
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

git clone https://github.com/qameta/allure-docker-compose.git && \
mkdir ~/allure-testops && \
cp ${PWD}/allure-docker-compose/docker-compose.yml ~/allure-testops && \
cp ${PWD}/allure-docker-compose/env-example ~/allure-testops/.env && \
cp -r ${PWD}/allure-docker-compose/configs ~/allure-testops/ && \
cd ~/allure-testops

read -p "Please enter docker login token to access Qameta's private registry: " SECRET_TOKEN

docker login -u qametaaccess -p ${SECRET_TOKEN}

docker compose pull && docker compose up -d && docker compose logs -f 
