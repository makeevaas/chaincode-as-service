#!/bin/bash
#
./network.sh down
docker volume prune
docker network prune
docker system prune