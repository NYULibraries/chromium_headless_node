#!/bin/sh -ex

for version in 8 10 12
do
  BASE_IMAGE=chromium_headless_node:$version
  patch_version=`echo -n $version | sed -e 's/\..$//g'`
  major_version=`echo -n $version | sed -e 's/\.\S*//g'`
  # grabs version number from Node & Chromium installations, stripping extraneous text
  NODE_VERSION=$(docker-compose run node_$major_version node --version | sed 's/v//')
  CHROMIUM_VERSION=$(docker-compose run node_$major_version chromium-browser --version | sed 's/Chromium //')

  # TAG COMMANDS
  docker tag $BASE_IMAGE quay.io/nyulibraries/$BASE_IMAGE-chromium_latest
  docker tag $BASE_IMAGE quay.io/nyulibraries/$BASE_IMAGE-chromium_$CHROMIUM_VERSION-${CIRCLE_BRANCH//\//_}
  docker tag $BASE_IMAGE quay.io/nyulibraries/$BASE_IMAGE-chromium_$CHROMIUM_VERSION-${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}

  # PUSH COMMANDS
  docker push quay.io/nyulibraries/$BASE_IMAGE-chromium_latest
  docker push quay.io/nyulibraries/$BASE_IMAGE-chromium_$CHROMIUM_VERSION-${CIRCLE_BRANCH//\//_}
  docker push quay.io/nyulibraries/$BASE_IMAGE-chromium_$CHROMIUM_VERSION-${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}

  if [[ "$CIRCLE_BRANCH" = "master" ]]
  then
    # TAG
    docker tag $BASE_IMAGE quay.io/nyulibraries/$BASE_IMAGE-chromium_$CHROMIUM_VERSION
    # PUSH
    docker push quay.io/nyulibraries/$BASE_IMAGE-chromium_$CHROMIUM_VERSION
  fi
done
