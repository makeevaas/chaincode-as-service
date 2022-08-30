#!/bin/bash
#
CONTAINER_CLI=podman ./network.sh down
podman volume prune
podman network prune
podman system prune