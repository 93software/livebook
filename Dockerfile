FROM elixir:1.12.0-rc.0-alpine AS build

# install build dependencies
RUN apk add --no-cache build-base npm git

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get --only prod, deps.compile

# copy pre-built static assets
COPY priv priv

# compile project
COPY lib lib
RUN mix compile

CMD ["mix", "phx.server"]
