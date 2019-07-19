#!/bin/sh -ex

for version in 8 10 12
do
  BASE_IMAGE=chromium_headless_node:$version
  # grabs version number from Node & Chromium installations, stripping extraneous text
  NODE_VERSION=`docker run alpine/semver semver -c $(docker-compose run node_$version node --version)`
  CHROMIUM_VERSION=`docker run alpine/semver semver -c $(docker-compose run node_$version chromium-browser --version)`

  # TAG COMMANDS
  docker tag $BASE_IMAGE quay.io/nyulibraries/chromium_headless_node:$version-chromium_latest
  docker tag $BASE_IMAGE quay.io/nyulibraries/chromium_headless_node:$NODE_VERSION-chromium_latest
  docker tag $BASE_IMAGE quay.io/nyulibraries/chromium_headless_node:$NODE_VERSION-chromium_$CHROMIUM_VERSION-${CIRCLE_BRANCH//\//_}
  docker tag $BASE_IMAGE quay.io/nyulibraries/chromium_headless_node:$NODE_VERSION-chromium_$CHROMIUM_VERSION-${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}

  # PUSH COMMANDS
  docker push quay.io/nyulibraries/chromium_headless_node:$NODE_VERSION-chromium_latest
  docker push quay.io/nyulibraries/chromium_headless_node:$NODE_VERSION-chromium_$CHROMIUM_VERSION-${CIRCLE_BRANCH//\//_}
  docker push quay.io/nyulibraries/chromium_headless_node:$NODE_VERSION-chromium_$CHROMIUM_VERSION-${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}

  if [[ $CIRCLE_BRANCH == master ]]
  then
    # TAG
    docker tag $BASE_IMAGE quay.io/nyulibraries/chromium_headless_node:$NODE_VERSION-chromium_$CHROMIUM_VERSION
    # PUSH
    docker push quay.io/nyulibraries/chromium_headless_node:$NODE_VERSION-chromium_$CHROMIUM_VERSION
  fi
done
