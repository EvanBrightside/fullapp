# README

## Requirements

Docker (https://docs.docker.com/get-docker/)

Docker-compose (https://docs.docker.com/compose/install/)

## Setup

* run `git clone git@github.com:EvanBrightside/fullapp.git`

* run `cd fullapp`

* run `docker-compose run --rm --no-deps fullapp rails new . --force --skip-test --javascript esbuild --css tailwind --database=postgresql`

* run `docker-compose run --rm -e RAILS_ENV=development fullapp bundle add foreman"`

* update your `/config/database.yml` with:

  ```text
  default: &default
    adapter: postgresql
    encoding: unicode
    pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
    host: <%= ENV.fetch('APP_DB_HOST', 'postgres') %>
    port: <%= ENV.fetch('APP_DB_PORT', '5432') %>
    username: <%= ENV.fetch('APP_DB_USERNAME', 'postgres') %>

  development:
    <<: *default
    database: <%= ENV.fetch('APP_DB_NAME', 'fullapp_development') %>

  test:
    <<: *default
    database: <%= ENV.fetch('APP_DB_NAME', 'fullapp_test') %>

  production:
    <<: *default
    pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 20 } %>
    database: <%= ENV.fetch('APP_DB_NAME_ENV', 'fullapp_production') %>
    username: <%= ENV.fetch('APP_DB_USERNAME_ENV', 'fullapp') %>
    password: <%= ENV['APP_DATABASE_PASSWORD'] %>
  ```

* run `docker-compose build`

* run `docker-compose run --rm -e RAILS_ENV=development fullapp rake db:create`

* run `docker-compose up fullapp`

## Usage

* <http://0.0.0.0:3000>
