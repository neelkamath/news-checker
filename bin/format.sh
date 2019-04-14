#!/usr/bin/env bash

# If there are poorly formatted Dart files, this script will output such and then exit with a status code of 1.

if dartfmt -n --fix . | grep '.dart'; then
    echo 'The above files have not been formatted';
    exit 1;
fi