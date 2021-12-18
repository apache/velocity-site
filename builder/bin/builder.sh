#!/usr/bin/env bash

DOCKER_NAME=velocity-site-builder
PORT=8000

# exit on failures and undeclared variables, echo commands
set -o errexit
set -o nounset
set -o pipefail

# debugging
#set -o xtrace

# Determine the real location of the script, past symlinks.
# (source: https://stackoverflow.com/a/246128/710286 )
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  TARGET="$(readlink "$SOURCE")"
  if [[ $TARGET == /* ]]; then
    SOURCE="$TARGET"
  else
    DIR="$( dirname "$SOURCE" )"
    SOURCE="$DIR/$TARGET" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  fi
done

# get repository root
cd $( dirname "$SOURCE" )/../..
if test ! -f .asf.yaml
then
    echo Could not find root of velocity-site git repository
    exit 1
fi
ROOT=$( pwd )
rm -rf target/*
mkdir -p target

# check docker is installed
if [ ! -x "$(command -v docker)" ]; then
    echo "Install docker on your system and try again..."
    exit 1
fi

# check that velocity-site-prod (velocity-site on the asf-site branch) is cloned in a sibling directory
cd "$ROOT/.."
BASE=$( pwd )
if test ! -d velocity-site-prod
then
    echo the site builder needs a clone of velocity-site under the asf-site branch in the velocity-site-prod directory in the same parent directory than velocity-site.
    read -n1 -p "Shall I create it for you?" answer
    echo
    if [[ "$answer" =~ ^[Yy]$ ]]
    then
        git clone --single-branch --branch asf-site https://github.com/apache/velocity-site.git velocity-site-prod
    fi
fi
if test ! -d velocity-site-prod
then
   echo velocity-site-prod repository not present, exiting
   exit 1
fi
cd velocity-site-prod
BRANCH="$(git status -bs | head -1 | sed -r -e 's,^.*origin/,,')"
if test "$BRANCH" != "asf-site"
then
    echo velocity-site-prod repository not on the asf-site branch, exiting
fi

# The philosophy here is to cache the image but not the container.

# stop previous container if present
if [ "$(docker ps -q -f name=$DOCKER_NAME)" ]
then
    docker stop $DOCKER_NAME
fi

# remove previous container if present
if [ "$(docker ps -aq -f status=exited -f name=$DOCKER_NAME)" ]
then
    docker rm -v $DOCKER_NAME
fi

# build the image if necessary
if [[ "$(docker images -q $DOCKER_NAME 2> /dev/null)" == "" ]]; then
    docker build --file="$ROOT/builder/src/docker/Dockerfile" -t $DOCKER_NAME "$ROOT/builder/src/docker"
fi

# do the voodoo
docker run --rm -ti --name $DOCKER_NAME -u "$(id -u):$(id -g)" --volume="$BASE:/home/velocity" --publish 127.0.0.1:$PORT:8000 $DOCKER_NAME

# alternatively, if you need to debug the container (as root), comment the previous command and run instead:
# docker run -it --name $DOCKER_NAME --volume="$BASE:/home/velocity" --entrypoint=/bin/bash velocity-site-builder
