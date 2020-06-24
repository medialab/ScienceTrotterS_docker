## Pre-build static application
FROM node:8.9.3 AS mobile_app

ARG API_URL=http://localhost:8080/api
ENV API_URL=${API_URL}

WORKDIR /mobile_app

# jq in Debian repo is too old to get env vars
RUN wget -O /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && \
  chmod +x /usr/local/bin/jq

COPY /ScienceTrotterS_mobile/package.json /mobile_app/package.json
COPY /ScienceTrotterS_mobile/config.xml /mobile_app/config.xml

RUN npm install -g cordova@9.0.0 \
  	&& npm install ionic@3.19.1 \
    && npm install

COPY /ScienceTrotterS_mobile /mobile_app

RUN jq '.configuration.endpoint.data=env.API_URL | .configuration.endpoint.assets="\(env.API_URL)/ressources/upload/"' src/manifest.json > src/manifest.new.json

RUN mv src/manifest.new.json src/manifest.json

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
