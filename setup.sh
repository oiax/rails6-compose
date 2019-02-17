#!/bin/bash
set -eu

case "$OSTYPE" in
  darwin*)
    docker-compose build web
    ;;
  msys*)
    docker-compose build web
    ;;
  linux*)
    docker-compose build --build-arg UID=$(id -u) --build-arg GID=$(id -g) web
    ;;
  *)
    echo "Unknown OS Type: $OSTYPE"
    ;;
esac
