#!/usr/bin/env bash

set -e

while [ true ]
do
    php artisan schedule:run --verbose --no-interaction & sleep 60
done
