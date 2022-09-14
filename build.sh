for i in 8 10 12 14
do
  SERVICE=alpine_node_${i}
  docker-compose build ${SERVICE}
  CHROMIUM_VERSION=$(docker-compose run ${SERVICE} chromium-browser --version | cut -d " " -f 2)
  NODE_VERSION=$(docker-compose run ${SERVICE} node --version | cut -d "v" -f 2)
  docker tag ${IMAGE} chromium_headless_node:node_${NODE_VERSION}_chromium_${CHROMIUM_VERSION}
done
