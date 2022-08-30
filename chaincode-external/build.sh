#!/bin/bash
#
#docker build -f Dockerfile -t cc_image:0.1 --build-arg CC_SERVER_PORT=9999 .
podman build -f Dockerfile -t cc_image:0.1 --build-arg CC_SERVER_PORT=9999 .

#cp basic.tar.gz ../fabric-samples/test-network