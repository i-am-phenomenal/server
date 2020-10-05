# # # ./Dockerfile

# # # Extend from the official Elixir image
# # FROM elixir:latest

# # # Create app directory and copy the Elixir projects into it
# # RUN mkdir /app
# # COPY . /app
# # WORKDIR /app
# #===========
# # FROM bitwalker/alpine-elixir:1.5 as build

# # #Copy the source folder into the Docker image
# # COPY . .

# # #Install dependencies and build Release
# # RUN export MIX_ENV=prod && \
# #     rm -Rf _build && \
# #     mix deps.get && \
# #     mix release

# # #Extract Release archive to /rel for copying in next stage
# # RUN APP_NAME="MY_APP_NAME" && \
# #     RELEASE_DIR=`ls -d _build/prod/rel/$APP_NAME/releases/*/` && \
# #     mkdir /export && \
# #     tar -xf "$RELEASE_DIR/$APP_NAME.tar.gz" -C /export

# # #================
# # #Deployment Stage
# # #================
# # FROM pentacent/alpine-erlang-base:latest

# # #Set environment variables and expose port
# # EXPOSE 4000
# # ENV REPLACE_OS_VARS=true \
# #     PORT=4000

# # #Copy and extract .tar.gz Release file from the previous stage
# # COPY --from=build /export/ .

# # #Change user
# # USER default

# # #Set default entrypoint and command
# # ENTRYPOINT ["/opt/app/bin/MY_APP_NAME"]
# # CMD ["foreground"]
# # # Install hex package manager
# # # By using --force, we don’t need to type “Y” to confirm the installation
# # RUN mix local.hex --force

# # # Compile the project
# # RUN mix do compile
# # CMD ["/app/entrypoint.sh"]

# #  File: my_app/Dockerfile
# # FROM elixir:1.9-alpine as build

# # # install build dependencies
# # RUN apk add --update git build-base nodejs npm yarn python

# # RUN mkdir /app
# # WORKDIR /app

# # install Hex + Rebar
# # RUN mix do local.hex --force, local.rebar --force

# # set build ENV
# # ENV MIX_ENV=prod

# # install mix dependencies
# # COPY mix.exs mix.lock ./
# # COPY config config
# # RUN mix deps.get --only $MIX_ENV
# # RUN mix deps.compile

# # build assets
# # COPY assets assets
# # RUN cd assets && npm install && npm run deploy
# # RUN mix phx.digest

# # build project
# # COPY priv priv
# # COPY lib lib
# # RUN mix compile

# # build release
# # at this point we should copy the rel directory but
# # we are not using it so we can omit it
# # COPY rel rel
# # RUN mix release

# # prepare release image
# # FROM alpine:3.9 AS app

# # # install runtime dependencies
# # RUN apk add --update bash openssl postgresql-client

# # EXPOSE 4000
# # ENV MIX_ENV=prod

# # # prepare app directory
# # RUN mkdir /app
# # WORKDIR /app

# # # copy release to app container
# # COPY --from=build /app/_build/prod/rel/my_app .
# # COPY entrypoint.sh .
# # RUN chown -R nobody: /app
# # USER nobody

# # ENV HOME=/app
# # CMD ["bash", "/app/entrypoint.sh"]
# # FROM elixir:1.9.0-alpine AS build

# # ARG SKIP_PHOENIX=false
# # ARG PHOENIX_SUBDIR=.

# # WORKDIR /opt/app

# # RUN apk update && \
# #   apk upgrade --no-cache && \
# #   apk add ca-certificates wget && \
# #   update-ca-certificates && \
# #   apk --update add imagemagick && \
# #   apk add --update util-linux && \
# #   apk add bash && \
# #   apk add openssl-dev && \
# #   apk add coreutils && \
# #   apk add --no-cache \
# #     nodejs \
# #     nodejs-npm \
# #     yarn \
# #     git \
# #     build-base && \
# #   mix local.rebar --force && \
# #   mix local.hex --force

# # COPY . .

# # RUN mix do deps.get && \
# #     chmod +x entrypoint.sh

# # RUN if [ ! "$SKIP_PHOENIX" = "true" ]; then\
# #   cd ${PHOENIX_SUBDIR}/assets && \
# #   yarn install && \
# #   yarn deploy && \
# #   cd .. && \
# #   mix phx.digest; \
# #   mix ecto.create \
# #   mix ecto.migrate \
# #   mix phx.server

# #   fi
# # install build dependencies
# # RUN apk add --no-cache build-base npm git python openssl postgresql-client

# # prepare build dir
# # WORKDIR /app

# # install hex + rebar
# # RUN mix local.hex --force && \
# #     mix local.rebar --force

# # # set build ENV
# # ENV MIX_ENV=prod

# # # install mix dependencies
# # COPY mix.exs mix.lock ./
# # COPY config config
# # RUN mix do deps.get, deps.compile

# # # build assets
# # COPY assets/package.json assets/package-lock.json ./assets/
# # RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

# # COPY priv priv
# # COPY assets assets
# # RUN npm run --prefix ./assets deploy
# # RUN mix phx.digest

# # # compile and build release
# # COPY lib lib
# # # uncomment COPY if rel/ exists
# # # COPY rel rel
# # RUN mix do compile, release

# # # prepare release image
# # FROM alpine:3.9 AS app
# # RUN apk add --no-cache openssl ncurses-libs

# # WORKDIR /app

# # RUN chown nobody:nobody /app

# # USER nobody:nobody

# # # COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/my_app .

# # ENV HOME=/app

# # # CMD ["bin/my_app", "start"]
# # # CMD  ["bash", "/app/entrypoint.sh"]
# # RUN mix

# # FROM bitwalker/alpine-elixir-phoenix:latest

# # WORKDIR /app

# # # COPY mix.exs .
# # # COPY mix.lock .

# # RUN mkdir assets

# # # COPY assets/package.json assets
# # # COPY assets/package-lock.json assets
# # COPY . .
# # CMD mix deps.get && cd assets && npm install && cd .. && mix phx.server

# FROM elixir:1.10.4-alpine  AS builder

# WORKDIR /opt/app

# RUN apk update && \
#   apk upgrade --no-cache && \
#   apk add ca-certificates wget && \
#   update-ca-certificates && \
#   apk --update add imagemagick && \
#   apk add --update util-linux && \
#   apk add bash && \
#   apk add openssl-dev && \
#   apk add coreutils && \
#   apk add --no-cache \
#     nodejs \
#     nodejs-npm \
#     yarn \
#     git \
#     build-base && \
#   mix local.rebar --force && \
#   mix local.hex --force

# # COPY mix.exs .
# # COPY mix.lock .

# # RUN mkdir assets

# # COPY assets/package.json assets
# # COPY assets/package-lock.json assets

# # CMD mix deps.get && cd assets && npm install && cd .. && mix phx.server
# # This copies our app source code into the build container
# COPY . .

# RUN mix do deps.get && \
#     chmod +x start.sh

# # This step builds assets for the Phoenix app (if there is one)
# # If you aren't building a Phoenix app, pass `--build-arg SKIP_PHOENIX=true`
# # This is mostly here for demonstration purposes
# RUN if [ ! "$SKIP_PHOENIX" = "true" ]; then\
#   cd ${PHOENIX_SUBDIR}/assets && \
#   yarn install && \
#   yarn deploy && \
#   cd .. && \
#   mix phx.digest; \
#   fi

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

# ARG API_KEYS
# ARG CHAT_APP_GUARDIAN_TOKEN
ARG DATABASE_URL
# ARG DEPLOY_TARGET
# ARG HOST
# ARG IMPORTER_OBIEE_HOST
# ARG IMPORTER_OBIEE_PASSWORD
# ARG IOS_SCHEME
# ARG ONE_SIGNAL_API_KEY
# ARG ONE_SIGNAL_APP_ID
# ARG PORT=4000
# ARG RECEIVERS
# ARG ROLLBAR_ACCESS_TOKEN
# ARG ROLLBAR_ENDPOINT
ARG SECRET_KEY_BASE
# ARG SEND_BIRD_API_TOKEN
# ARG SEND_BIRD_APP_ID
# ARG SENDGRID_API_KEY
# ARG POOL_SIZE
# ARG SEND_ALERTS
# ARG RECEIVERS_CLIENT_DETAIL
# ARG AUTH0_GUARDIAN_ISSUER

# ARG AWS_BUCKET
# ARG AWS_ACCESS_KEY_ID
# ARG SERVICE_MAIL
# ARG SERVICE_PASSWORD
# ARG WORKER_URL
# ARG PROXY_URL
# ARG GRANT_TYPE
# ARG AUTH0_USERNAME
# ARG AUTH0_PASSWORD
# ARG AUTH0_URL
# ARG CLIENT_ID
# ARG CLIENT_SECRET
# ARG PRIV_KEY_PATH
# ARG CF_SUBDOMAIN
# ARG IMG_EXPIRATION
# ARG CLOUDFRONT_ACCESS_ID
# ARG CF_KEY_PAIR_ID
# ARG SLACK_WEBHOOK
# ARG AWS_CERT_S3_FOLDER
# ARG CLOUDFRONT_CER_FILE_NAME
# ARG DOTCOM_API_KEY

# ENV APP_NAME=${APP_NAME} \
#     APP_VSN=${APP_VSN} \
#     SKIP_PHOENIX=${SKIP_PHOENIX} \
#     MIX_ENV=${MIX_ENV} \
# 	API_KEYS=${API_KEYS} \
# 	CHAT_APP_GUARDIAN_TOKEN=${CHAT_APP_GUARDIAN_TOKEN} \
ENV DATABASE_URL=postgres://postgres:l7JTzDvMMQNNzLiAKomL@elcdb.cssvhzicpepf.us-east-1.rds.amazonaws.com:5432/elcdb \
# 	DEPLOY_TARGET=${DEPLOY_TARGET} \
# 	HOST=${HOST} \
# 	IMPORTER_OBIEE_HOST=${IMPORTER_OBIEE_HOST} \
# 	IMPORTER_OBIEE_PASSWORD=${IMPORTER_OBIEE_PASSWORD} \
# 	IOS_SCHEME=${IOS_SCHEME} \
# 	ONE_SIGNAL_API_KEY=${ONE_SIGNAL_API_KEY} \
# 	ONE_SIGNAL_APP_ID=${ONE_SIGNAL_APP_ID} \
# 	PORT=${PORT} \
# 	RECEIVERS=${RECEIVERS} \
# 	ROLLBAR_ACCESS_TOKEN=${ROLLBAR_ACCESS_TOKEN} \
# 	ROLLBAR_ENDPOINT=${ROLLBAR_ENDPOINT} \
	SECRET_KEY_BASE=${SECRET_KEY_BASE} 
# 	SEND_BIRD_API_TOKEN=${SEND_BIRD_API_TOKEN} \
# 	SEND_BIRD_APP_ID=${SEND_BIRD_APP_ID} \
# 	SENDGRID_API_KEY=${SENDGRID_API_KEY} \
# 	POOL_SIZE=${POOL_SIZE} \
# 	RECEIVERS_CLIENT_DETAIL=${RECEIVERS_CLIENT_DETAIL} \
# 	AUTH0_GUARDIAN_ISSUER=${AUTH0_GUARDIAN_ISSUER} \
# 	SEND_ALERTS=${SEND_ALERTS} \
# 	AWS_BUCKET=${AWS_BUCKET} \
# 	AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
# 	WORKER_URL=${WORKER_URL} \
# 	PROXY_URL=${PROXY_URL} \
# 	GRANT_TYPE=${GRANT_TYPE} \
# 	AUTH0_USERNAME=${AUTH0_USERNAME} \
# 	AUTH0_PASSWORD=${AUTH0_PASSWORD} \
# 	AUTH0_URL=${AUTH0_URL} \
# 	CLIENT_ID=${CLIENT_ID} \
# 	CLIENT_SECRET=${CLIENT_SECRET} \
# 	PRIV_KEY_PATH=${CLOUDFRONT_CER_FILE_NAME} \
# 	CF_SUBDOMAIN=${CF_SUBDOMAIN} \
# 	IMG_EXPIRATION=${IMG_EXPIRATION} \
# 	CLOUDFRONT_ACCESS_ID=${CLOUDFRONT_ACCESS_ID} \
# 	CF_KEY_PAIR_ID=${CF_KEY_PAIR_ID} \
# 	SLACK_WEBHOOK=${SLACK_WEBHOOK} \
# 	DOTCOM_API_KEY=${DOTCOM_API_KEY} \
# 	AWS_CERT_S3_FOLDER=${AWS_CERT_S3_FOLDER}

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
RUN if [ ! "$SKIP_PHOENIX" = "true" ]; then\
  cd ${PHOENIX_SUBDIR}/assets && \
  yarn install && \
  yarn deploy && \
  cd .. && \
  mix phx.digest; \
  fi

# CMD trap 'exit' INT; mix ecto.create; mix ecto.migrate; mix phx.server
# ENTRYPOINT ["sh", "start.sh"]
