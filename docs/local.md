# Developing Locally

This document explains how to update this project's code.

# Installation

## Prerequisites

- [This app](get.md)
- [Server Dart 2](https://www.dartlang.org/tools/sdk#install)
- [PostgreSQL 10](https://www.postgresql.org/download/)

## Install

1. Check if the database has been started by entering `psql`. An interactive session will start if Postgres is running, and an error will display if it isn't. If the database hasn't been started, refer to [these](https://www.postgresql.org/docs/10/static/server-start.html) docs to start it.
1. Create the database by starting a psql terminal by entering `psql`, and then executing the following commands in it. 
    ```
    CREATE USER <USER> WITH CREATEDB;
    ALTER USER <USER> WITH PASSWORD '<PASSWORD>';
    CREATE DATABASE <DB>;
    GRANT ALL ON DATABASE <DB> to <USER>;
    ```
    Replace `<USER>` and `<PASSWORD>` with the username and password for the database's owner respectively, and `<DB>` with the name for the database.
1. Create a file `.env` with the following contents.
    ```
    NEWS_API_KEY=<KEY>
    DATABASE_URL=postgres://<USER>:<PASSWORD>@localhost:<PORT>/<DB>
    ```
    `<KEY>` is your News API key.
    `<USER>`, `<PASSWORD>`, and `<DB>` are the same values you had entered for these keys in the previous step.
    `<PORT>` is the port Postgres is running on (this will be `5432` unless you or your OS has set it differently).
    
# Usage

Start the server by running `heroku local start`.

# Testing

`heroku local test`

# Documentation 

You can quickly generate the HTTP API's documentation with [`bin/doc.dart`](../bin/doc.dart) (its usage is documented in the file). Run it with `dart bin/doc.dart`.
