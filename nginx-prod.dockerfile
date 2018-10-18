FROM nginx:1.13-alpine


ARG API_URL=http://localhost/api
ENV API_URL=${API_URL}

COPY /ScienceTrotterS_API /api
COPY /ScienceTrotterS_mobile /mobile_app
COPY /ScienceTrotterS_backoffice /backoffice

WORKDIR /mobile_app

RUN apk update \
    && apk add git nodejs jq \
	&& jq '.configuration.endpoint.data=env.API_URL | .configuration.endpoint.assets="\(env.API_URL)/ressources/uploads"' src/manifest.json > src/manifest.new.json \
	&& mv src/manifest.new.json src/manifest.json \
	&& npm install ionic@3.19.1 \
    && npm install \
    && npm run build\
    && npm cache clean --force \
    && apk del git nodejs jq \
    && rm -fr node_modules \
    && rm /var/cache/apk/*

COPY ./nginx-prod.conf /etc/nginx/conf.d/default.template

RUN apk --no-cache add shadow && usermod -u 82 nginx && groupmod -g 82 nginx

COPY nginx-prod.entrypoint /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
