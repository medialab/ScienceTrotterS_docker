FROM  node:8.9.3-alpine AS node


ENV API_URL=http://localhost:5000

ADD ./ScienceTrotterS_mobile /mobile_app

WORKDIR /mobile_app

RUN apk add --no-cache --virtual .build-deps git build-base jq \
    && jq '.configuration.endpoint.data=env.API_URL | .configuration.endpoint.assets="\(env.API_URL)/ressources/uploads"' src/manifest.json > src/manifest.new.json \
	&& mv src/manifest.new.json src/manifest.json \
	&& npm install ionic@3.19.1 \
    && npm install \
    && npm rebuild node-sass \
    && npm run build\
    && npm cache clean --force \   
    && apk del .build-deps \
    && rm -rf ./node_modules /root/.npm /root/.node-gyp /root/.config /usr/lib/node_modules

###

FROM nginx:alpine

RUN mkdir /mobile_app

COPY --from=node --chown=nginx:nginx /mobile_app /mobile_app

COPY ./mobile_app.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]

