# Note: run `make update-base-image` after editing this file.

FROM ruby:2.7.1-alpine3.12

ARG RAILS_ENV
ARG SECRET_KEY_BASE

RUN apk --update add --no-cache \
  build-base \
  curl \
  gcompat \
  git \
  libc-dev \
  libxml2-dev \
  linux-headers \
  mariadb-dev \
  ruby-dev \
  tzdata \
  yarn \
  sqlite-dev

WORKDIR /app

COPY . /app
COPY Gemfile Gemfile.lock ./
COPY vendor ./vendor

RUN bundle config set deployment 'true'
RUN bundle config set without 'test development'
RUN CFLAGS="-Wno-cast-function-type" \
  BUNDLE_FORCE_RUBY_PLATFORM=1 \
  bundle install --jobs=4

RUN yarn install

RUN echo $RAILS_ENV
RUN echo $SECRET_KEY_BASE

RUN bundle exec rails webpacker:compile

# Add all bin to PATH
ENV PATH "$PATH:/app/bin"

EXPOSE 3000

ENTRYPOINT ["bundle", "exec", "rails", "s"]
