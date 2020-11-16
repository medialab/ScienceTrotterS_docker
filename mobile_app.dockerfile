FROM node:12.9.0 AS node


ENV API_URL=http://localhost:5000

ADD ./ScienceTrotterS_mobile /mobile_app

WORKDIR /mobile_app

RUN apk add --no-cache --virtual .build-deps git build-base jq \
    %% sed -i "s@API_DATA_URL@${API_URL}@g" src/environments/environment.prod.ts \
    && npm install -g @ionic/cli \
    && npm install
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

