FROM ruby:3.3.0-slim-bullseye

# Minimal requirements to run a Rails app
RUN apt-get update && apt-get install -qq -y --no-install-recommends \
    build-essential \
    wget \
    libpq-dev \
    git \
    tzdata \
    libxml2-dev \
    libxslt-dev \
    libvips \
    curl \
    gnupg \
    cron \
    ssh && rm -rf /var/lib/apt/lists/*

# Install node and yarn
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - &&\
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -qq -y --no-install-recommends build-essential nodejs yarn \
    && rm -rf /var/lib/apt/lists/*

ENV APP_NAME /fullapp
RUN mkdir /$APP_NAME
WORKDIR /$APP_NAME

COPY Gemfile* $APP_NAME

ENV BUNDLE_PATH=/bundle \
    BUNDLE_JOBS=3 \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

ENV BUNDLER_VERSION 2.3.22
RUN gem update --system && gem install bundler -v $BUNDLER_VERSION
RUN bundle install

COPY . /$APP_NAME
