#!/bin/sh
set -e

docker build -t webpgf-build .

docker run -it --rm -u $(id -u):$(id -g) -v $(pwd)/:/src webpgf-build make build
