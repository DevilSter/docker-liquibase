#!/bin/bash

sudo docker build -f Dockerfile --build-arg LB_VER=3.1.1 -t devilster/liquibase:3.1 .
sudo docker build -f Dockerfile --build-arg LB_VER=3.3.5 -t devilster/liquibase:3.3 .
sudo docker build -f Dockerfile --build-arg LB_VER=3.5.4 -t devilster/liquibase -t devilster/liquibase:3.5 .

sudo docker push devilster/liquibase
sudo docker push devilster/liquibase:3.1
sudo docker push devilster/liquibase:3.3
sudo docker push devilster/liquibase:3.5
