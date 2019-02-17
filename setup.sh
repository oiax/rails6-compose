#!/bin/bash
set -eu

docker-compose build db

case "$OSTYPE" in
  darwin*)
    docker-compose build web
    ;;
  linux*)
    docker-compose build --build-arg UID=$(id -u) --build-arg GID=$(id -g) web
    ;;
  *)
    echo "Unknown OS Type: $OSTYPE"
    ;;
esac
