#!/bin/bash

sudo docker build -f Dockerfile --build-arg LB_VER=3.1.1 -t evangistudio/liquibase:3.1 .
sudo docker build -f Dockerfile --build-arg LB_VER=3.3.5 -t evangistudio/liquibase:3.3 .
sudo docker build -f Dockerfile --build-arg LB_VER=3.5.4 -t evangistudio/liquibase -t evangistudio/liquibase:3.5 .

sudo docker push evangistudio/liquibase
sudo docker push evangistudio/liquibase:3.1
sudo docker push evangistudio/liquibase:3.3
sudo docker push evangistudio/liquibase:3.5
