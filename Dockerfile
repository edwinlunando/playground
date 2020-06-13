# Note: run `make update-base-image` after editing this file.

FROM ruby:2.7.1-alpine3.12

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

COPY Gemfile Gemfile.lock ./
COPY vendor ./vendor
RUN CFLAGS="-Wno-cast-function-type" \
  BUNDLE_FORCE_RUBY_PLATFORM=1 \
  bundle install --clean --deployment --without test development --jobs=4

RUN yarn install

RUN bundle exec rails webpacker:compile

COPY . .

EXPOSE 3000

ENTRYPOINT ["bundle", "exec", "rails", "s"]
