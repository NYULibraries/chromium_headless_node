#!/bin/sh -ex

for version in 6.16.0 8.15.0 10.15.1
do
  BASE_IMAGE=chromium_headless_node:$version
  CHROMIUM_VERSION=$(docker run $BASE_IMAGE chromium-browser --version | cut -d " " -f 2 )
  docker tag $BASE_IMAGE quay.io/nyulibraries/$BASE_IMAGE-chromium_$CHROMIUM_VERSION-${CIRCLE_BRANCH//\//_}
  docker tag $BASE_IMAGE quay.io/nyulibraries/$BASE_IMAGE-chromium_$CHROMIUM_VERSION-${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
  if [[ "$CIRCLE_BRANCH" = "master" ]]
  then
    docker tag $BASE_IMAGE quay.io/nyulibraries/$BASE_IMAGE-chromium_$CHROMIUM_VERSION
  fi
done

for version in 6.16.0 8.15.0 10.15.1
do
  docker push quay.io/nyulibraries/$BASE_IMAGE-chromium_$CHROMIUM_VERSION-${CIRCLE_BRANCH//\//_}
  docker push quay.io/nyulibraries/$BASE_IMAGE-chromium_$CHROMIUM_VERSION-${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
  if [[ "$CIRCLE_BRANCH" = "master" ]]
  then
    docker push quay.io/nyulibraries/$BASE_IMAGE-chromium_$CHROMIUM_VERSION
  fi
done
