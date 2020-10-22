## Pre-build static application
FROM node:12.9.0 AS mobile_app

ARG API_URL=http://localhost:8080/api
ENV API_URL=${API_URL}

ENV PHP_HOST=php
ENV PHP_PORT=9000

WORKDIR /mobile_app

# jq in Debian repo is too old to get env vars
RUN wget -O /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && \
  chmod +x /usr/local/bin/jq

COPY /ScienceTrotterS_mobile/package.json /mobile_app/package.json
# COPY /ScienceTrotterS_mobile/config.xml /mobile_app/config.xml

RUN npm install -g @ionic/cli \
    && npm install

COPY /ScienceTrotterS_mobile /mobile_app

RUN sed -i "s@API_DATA_URL@${API_URL}@g" src/environments/environment.prod.ts

RUN npm rebuild node-sass

RUN npm run build

## Pack API & build app in an nginx container
FROM nginx:1.13-alpine

COPY /ScienceTrotterS_API /api
COPY --from=mobile_app --chown=nginx:nginx /mobile_app /mobile_app

COPY ./nginx-api-mobile.conf /etc/nginx/conf.d/default.template

RUN apk --no-cache add shadow && usermod -u 82 nginx && groupmod -g 82 nginx

COPY nginx-prod.entrypoint /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
