# # # ./Dockerfile
ARG ALPINE_VERSION=3.8

FROM elixir:1.10.4-alpine  AS builder

# The following are build arguments used to change variable parts of the image.

# The name of your application/release (required)
ARG APP_NAME
# The version of the application we are building (required)
ARG APP_VSN
# The environment to build with
ARG MIX_ENV=prod
# Set this to true if this release is not a Phoenix app
ARG SKIP_PHOENIX=false
# The version of Alpine to use for the final image
# If you are using an umbrella project, you can change this
# argument to the directory the Phoenix app is in so that the assets
# can be built
ARG PHOENIX_SUBDIR=.

ARG DATABASE_URL

ARG SECRET_KEY_BASE

ENV DATABASE_URL=postgres://postgres:l7JTzDvMMQNNzLiAKomL@elcdb.cssvhzicpepf.us-east-1.rds.amazonaws.com:5432/elcdb \

	SECRET_KEY_BASE=${SECRET_KEY_BASE} 

# By convention, /opt is typically used for applications
WORKDIR /opt/app

# This step installs all the build tools we'll need
RUN apk update && \
  apk upgrade --no-cache && \
  apk add ca-certificates wget && \
  update-ca-certificates && \
  apk --update add imagemagick && \
  apk add --update util-linux && \
  apk add bash && \
  apk add openssl-dev && \
  apk add coreutils && \
  apk add --no-cache \
    nodejs \
    nodejs-npm \
    yarn \
    git \
    build-base && \
  mix local.rebar --force && \
  mix local.hex --force

# This copies our app source code into the build container
COPY . .

RUN mix do deps.get && \
    chmod +x start.sh

# This step builds assets for the Phoenix app (if there is one)
# If you aren't building a Phoenix app, pass `--build-arg SKIP_PHOENIX=true`
# This is mostly here for demonstration purposes

# CMD trap 'exit' INT; mix ecto.create; mix ecto.migrate; mix phx.server
# ENTRYPOINT ["sh", "start.sh"]
