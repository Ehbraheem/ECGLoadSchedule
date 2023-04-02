# ARG RUBY_VERSION=3.2.2
# FROM ruby:$RUBY_VERSION-slim as base

# # Rack app lives here
# WORKDIR /app

# # Update gems and bundler
# RUN gem update --system --no-document && \
#     gem install -N bundler


# # Throw-away build stage to reduce size of final image
# FROM base as build

# # Install packages needed to build gems
# RUN apt-get update -qq && \
#     apt-get install --no-install-recommends -y build-essential postgresql-client libpq-dev

# # Install application gems
# COPY Gemfile* .
# RUN bundle install


# # Final stage for app image
# FROM base

# # Run and own the application files as a non-root user for security
# RUN useradd ruby --home /app --shell /bin/bash
# USER ruby:ruby

# # Copy built artifacts: gems, application
# COPY --from=build /usr/local/bundle /usr/local/bundle
# COPY --from=build --chown=ruby:ruby /app /app

# # Copy application code
# COPY . .




FROM ruby:3.2.2-alpine3.17 as build


ENV APP_DIR=/app \
    BUILD_PACKAGES="build-base curl-dev git" \
    DEV_PACKAGES="postgresql-dev yaml-dev zlib-dev util-linux libpq" \
    RUBY_PACKAGES="tzdata"


WORKDIR $APP_DIR


RUN apk update \
  && apk upgrade \
  && apk add --update --no-cache $BUILD_PACKAGES $DEV_PACKAGES $RUBY_PACKAGES


COPY Gemfile* $APP_DIR/


RUN gem install bundler --pre --no-document \
  && bundle config set frozen 1 \
  && bundle config set without 'test:development' \
  && bundle install --jobs 4 --retry 5 \
  && rm -rf /usr/local/bundle/cache/*.gem \
  && find /usr/local/bundle/gems/ -name "*.c" -delete \
  && find /usr/local/bundle/gems/ -name "*.o" -delete

COPY . $APP_DIR


FROM ruby:3.2.2-alpine3.17

ARG PACKAGES="tzdata libpq"

ENV SERVICE_USER=ecg \
    SERVICE_USER_ID=1001 \
    SERVICE_GROUP=ecg \
    SERVICE_GROUP_ID=1001 \
    APP_DIR=/app

WORKDIR $APP_DIR


RUN addgroup -g $SERVICE_GROUP_ID $SERVICE_GROUP \
  && adduser -D -u $SERVICE_USER_ID -G $SERVICE_GROUP $SERVICE_USER \
  && chown -R $SERVICE_USER:$SERVICE_GROUP $APP_DIR


RUN apk update \
  && apk upgrade \
  && apk add --update --no-cache $PACKAGES \
  && rm -rf /var/cache/apk/* \
  && rm -rf /tmp/* \
  && rm -rf /var/tmp/*


RUN gem install bundler --pre --no-document

USER $SERVICE_USER

COPY --chown=$SERVICE_USER:$SERVICE_GROUP --from=build /usr/local/bundle/ /usr/local/bundle/
COPY --chown=$SERVICE_USER:$SERVICE_GROUP --from=build $APP_DIR $APP_DIR


USER $SERVICE_USER
ENV MALLOC_ARENA_MAX=2

# Start the server
EXPOSE 8080
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "--port", "8080", "--env", "production", "-s", "puma"]
