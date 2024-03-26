#!/bin/sh -ex

for version in 12 14 16 18 20
do
  BASE_IMAGE=chromium_headless_node:$version
  # grabs version number from Node & Chromium installations, stripping extraneous text
  NODE_VERSION=`docker run alpine/semver semver -c $(docker-compose run node_$version node --version)`
  CHROMIUM_VERSION=`docker run alpine/semver semver -c $(docker-compose run node_$version chromium-browser --version)`

  # Make tags
  tags="$NODE_VERSION-chromium_$CHROMIUM_VERSION-${CIRCLE_BRANCH//\//_}"
  tags="$tags $NODE_VERSION-chromium_$CHROMIUM_VERSION-${CIRCLE_BRANCH//\//_}-$CIRCLE_SHA1"

  for tag in $tags
  do
    docker tag $BASE_IMAGE quay.io/nyulibraries/chromium_headless_node:$tag
    docker push quay.io/nyulibraries/chromium_headless_node:$tag
  done

  if [[ $CIRCLE_BRANCH == master ]]
  then
    tags="$version-chromium_latest"
    tags="$tags $NODE_VERSION-chromium_latest"
    tags="$tags $NODE_VERSION-chromium_$CHROMIUM_VERSION"

    for tag in $tags
    do
      docker tag $BASE_IMAGE quay.io/nyulibraries/chromium_headless_node:$tag
      docker push quay.io/nyulibraries/chromium_headless_node:$tag
    done
  fi
done
