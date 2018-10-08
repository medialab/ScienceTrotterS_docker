FROM nginx:alpine

ENV API_URL=http://localhost:5000

COPY /ScienceTrotterS_mobile /mobile_app

WORKDIR /mobile_app

RUN apk --update add git nodejs jq npm\
	&& jq '.configuration.endpoint.data=env.API_URL | .configuration.endpoint.assets="\(env.API_URL)/ressources/uploads"' src/manifest.json > src/manifest.new.json \
	&& mv src/manifest.new.json src/manifest.json \
	&& npm install ionic@3.19.1 \
    && npm install \
    && npm run build\
    && npm cache clean --force \
    && apk del git nodejs npm\
    && rm -fr node_modules \
    && rm /var/cache/apk/*

COPY ./mobile_app.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
