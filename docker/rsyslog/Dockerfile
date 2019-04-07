FROM elixir:1.8.1-alpine AS build

WORKDIR /etc/rsyslog
COPY ./docker/rsyslog/cookie/prod_cookie .

WORKDIR /build
COPY config ./config
COPY lib ./lib
COPY rel ./rel
COPY mix.exs .
COPY mix.lock .

RUN mix local.hex --force     && \
    mix deps.get              && \
    MIX_ENV=prod mix release

RUN APP_NAME="rsyslog" && \
    RELEASE_DIR=`ls -d _build/prod/rel/$APP_NAME/releases/*/` && \
    mkdir /export && \
    tar -xf "$RELEASE_DIR/$APP_NAME.tar.gz" -C /export
  
#######################################

FROM bitwalker/alpine-erlang:latest

USER default
COPY --from=build /export/ .

WORKDIR /etc/rsyslog/cookie
COPY --from=build /etc/rsyslog/prod_cookie .

WORKDIR /etc/rsyslog/certs
COPY ./docker/rsyslog/certs/ .

ENTRYPOINT ["/opt/app/bin/rsyslog"]
CMD ["console"]