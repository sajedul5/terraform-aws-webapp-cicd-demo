FROM nginx:1.27-alpine

ARG APP_VERSION=local
ARG BUILD_TIME=unknown

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html style.css script.js /usr/share/nginx/html/

RUN sed -i "s|__APP_VERSION__|${APP_VERSION}|; s|__BUILD_TIME__|${BUILD_TIME}|" /usr/share/nginx/html/index.html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -qO- http://127.0.0.1/health || exit 1
