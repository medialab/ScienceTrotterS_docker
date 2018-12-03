FROM nginx:1.13-alpine


ARG API_URL=http://localhost/api
ENV API_URL=${API_URL}

COPY /ScienceTrotterS_backoffice /backoffice

WORKDIR /mobile_app


COPY ./nginx-backoffice.conf /etc/nginx/conf.d/default.template

RUN apk --no-cache add shadow && usermod -u 82 nginx && groupmod -g 82 nginx

COPY nginx-prod.entrypoint /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
