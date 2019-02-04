#!/bin/sh -ex

for version in 6.16.0 8.15.0 10.15.1
do
  docker pull quay.io/nyulibraries/chromium_headless_node:$version-${CIRCLE_BRANCH//\//_} || \
  docker pull quay.io/nyulibraries/chromium_headless_node:$version-chromium_latest
done
