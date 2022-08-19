FROM docker.io/slatedocs/slate:v2.13.0 as builder

COPY source /srv/slate/source
RUN /srv/slate/slate.sh build

FROM docker.io/nginx:1.23.1-alpine

ENV NGINX_PORT=8080
COPY nginx.conf.template /etc/nginx/templates/default.conf.template
COPY --from=builder /srv/slate/build /usr/share/nginx/html
