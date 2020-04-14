#!/bin/sh

echo "waiting for $1"
until $(curl --output /dev/null --silent --head --fail $1); do
    printf '.'
    sleep 2
done