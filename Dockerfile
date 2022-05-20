# We want to stick with the lts-alpine tag, but need to ensure we explicitly track base images
# FROM docker.io/node:lts-alpine
FROM docker.io/node:16.15.0-alpine

ARG APP_ROOT=/opt/libreoffice
ENV NO_UPDATE_NOTIFIER=true \
  PATH="/usr/lib/libreoffice/program:${PATH}" \
  PYTHONUNBUFFERED=1

WORKDIR ${APP_ROOT}

COPY support ${APP_ROOT}/support

# Install LibreOffice & Common Fonts
RUN apk --no-cache add bash libreoffice \
                            ttf-droid-nonlatin ttf-droid ttf-dejavu ttf-freefont ttf-liberation && \
# Install Microsoft Core Fonts
  apk --no-cache add msttcorefonts-installer fontconfig && \
  update-ms-fonts && \
  fc-cache -f && \
# clean up
  rm -rf /var/cache/apk/* && \
# Fix Python/LibreOffice Integration
  chmod a+rx ${APP_ROOT}/support/bindPython.sh && \
  ${APP_ROOT}/support/bindPython.sh
