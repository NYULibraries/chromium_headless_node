#!/bin/sh -ex

for version in 8 10 12
do
  docker pull quay.io/nyulibraries/chromium_headless_node:$version-${CIRCLE_BRANCH//\//_} || \
  docker pull quay.io/nyulibraries/chromium_headless_node:$version-chromium_latest
done
