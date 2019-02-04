#!/bin/sh -ex

for version in 6.16.0 8.15.0 10.15.1
do
  patch_version=`echo -n $version | sed -e 's/\..$//g'`
  major_version=`echo -n $version | sed -e 's/\.\S*//g'`
  BASE_IMAGE=chromium_headless_node:$version
  docker tag $BASE_IMAGE quay.io/nyulibraries/$BASE_IMAGE-chromium_latest
  # grabs version number from Chromium installation
  CHROMIUM_VERSION=$(docker-compose run node_$major_version chromium-browser --version | cut -d " " -f 2)
  # CHROMIUM_VERSION=`echo -n $(docker-compose run node_$major_version chromium-browser --version | sed -e 's/[[:alpha:]|(|[:space:]]//g')`
  docker tag $BASE_IMAGE quay.io/nyulibraries/$BASE_IMAGE-chromium_$CHROMIUM_VERSION-${CIRCLE_BRANCH//\//_}
  docker tag $BASE_IMAGE quay.io/nyulibraries/$BASE_IMAGE-chromium_$CHROMIUM_VERSION-${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
  if [[ "$CIRCLE_BRANCH" = "master" ]]
  then
    docker tag $BASE_IMAGE quay.io/nyulibraries/$BASE_IMAGE-chromium_$CHROMIUM_VERSION
  fi
done

for version in 6.16.0 8.15.0 10.15.1
do
  docker push quay.io/nyulibraries/$BASE_IMAGE-chromium_latest
  docker push quay.io/nyulibraries/$BASE_IMAGE-chromium_$CHROMIUM_VERSION-${CIRCLE_BRANCH//\//_}
  docker push quay.io/nyulibraries/$BASE_IMAGE-chromium_$CHROMIUM_VERSION-${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
  if [[ "$CIRCLE_BRANCH" = "master" ]]
  then
    docker push quay.io/nyulibraries/$BASE_IMAGE-chromium_$CHROMIUM_VERSION
  fi
done
