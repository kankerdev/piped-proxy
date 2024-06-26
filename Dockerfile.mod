FROM nginx:mainline

ENV UDS=1 BIND_UNIX=/var/run/piped-proxy/actix.sock

WORKDIR /app/

RUN apt-get update && \
    apt-get install -yqq --no-install-recommends ca-certificates supervisor && \
    rm -rvf /var/lib/apt/lists/*

RUN mkdir -p /var/run/piped-proxy

COPY ./docker/nginx/nginx.conf /etc/nginx/
COPY ./docker/nginx/conf.d/app.conf /etc/nginx/conf.d/
COPY ./docker/nginx/snippets/proxy.conf /etc/nginx/snippets/
COPY ./docker/supervisord.conf /etc/supervisor/conf.d/

COPY ./bin/piped-proxy /app/piped-proxy

EXPOSE 80/tcp

ENTRYPOINT [ "/usr/bin/supervisord" ]
CMD ["-c", "/etc/supervisor/conf.d/supervisord.conf"]