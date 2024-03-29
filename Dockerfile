ARG NODE_VERSION
FROM node:${NODE_VERSION}-alpine

# Installs latest Chromium package.
RUN echo @edge http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories \
  && echo @edge http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories \
  && apk add --no-cache \
  chromium \
  harfbuzz@edge \
  nss@edge \
  && rm -rf /var/cache/*

# Autorun chrome headless with no GPU
CMD ["chromium-browser", "--headless", "--disable-gpu", "--disable-software-rasterizer", "--disable-dev-shm-usage"]
