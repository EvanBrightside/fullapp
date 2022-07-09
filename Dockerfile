FROM ruby:3.1.2-slim-bullseye

# Set locale
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US:en

RUN apt-get update -qq \
    && apt-get install -qq -y locales \
    && rm -rf /var/lib/apt/lists/* \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && echo "LANG=en_US.UTF-8" > /etc/default/locale \
    && locale-gen

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

ENV BUNDLER_VERSION 2.3.17
RUN gem update --system && gem install bundler -v $BUNDLER_VERSION
RUN bundle install

COPY . /$APP_NAME
