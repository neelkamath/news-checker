# Deploying Your Own Instance

This document explains how to deploy the server to Heroku.

# Deploying

## Prerequisites

- [This app](get.md).
- [Heroku account](https://signup.heroku.com)

## Deploy

1. Login: `heroku login`
1. Create an app: `heroku create <APP_NAME>`, where `<APP_NAME>` is an optionally passed name for your app (a randomly generated one will be generated for you if you do not specify one)
1. Set the location of the Dart SDK: `heroku config:set DART_SDK_URL=https://storage.googleapis.com/dart-archive/channels/stable/release/2.0.0/sdk/dartsdk-linux-x64-release.zip -a <APP_NAME>`, where `<APP_NAME>` is the name of this app
1. Provision the database: `heroku addons:create heroku-postgresql:<PLAN_NAME> -a <APP_NAME>`. `<PLAN_NAME>` is the name of the add-on's plan (e.g., `hobby-dev` is the free plan). You can check available plans [here](https://elements.heroku.com/addons/heroku-postgresql). `<APP_NAME>` is the name of this app.
1. Set the News API key: `heroku config:set NEWS_API_KEY=<KEY> -a <APP_NAME>`, where `<KEY>` is your News API key, and `<APP_NAME>` is the name of this app
1. Provision an add-on for logging: `heroku addons:create papertrail:<PLAN>`. `<PLAN>` is the add-on's plan (e.g., `choklad` is the free plan). You can check available plans [here](https://elements.heroku.com/addons/papertrail).
1. Push the code: `git push heroku master`

# Usage

You can start the server by running `heroku ps:scale web=<DYNOS> -a <APP_NAME>`, where `<DYNOS>` are the number of dynos you want the app to run on (e.g., `1`), and `<APP_NAME>` is the name of this app. 