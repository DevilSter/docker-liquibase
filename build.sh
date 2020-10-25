#!/bin/bash

sudo docker build -f Dockerfile --build-arg LIQUIBASE_VERSION=4.1.1 -t devilster/liquibase:4.1 .
sudo docker build -f Dockerfile --build-arg LIQUIBASE_VERSION=3.10.3 -t devilster/liquibase:3.10 .

sudo docker push devilster/liquibase
sudo docker push devilster/liquibase:4.1
sudo docker push devilster/liquibase:3.10
