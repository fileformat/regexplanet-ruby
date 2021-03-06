#!/bin/bash
#
# deploy to gcloud
#

cat app.yaml \
    | jq --sort-keys ".env_variables.LASTMOD|=\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"|.env_variables.COMMIT|=\"$(git rev-parse --short HEAD)\"" \
    | ex -sc 'wq!app.yaml' /dev/stdin

gcloud app deploy \
    --project regexplanet-ruby 

cat app.yaml \
    | jq 'del(.env_variables.LASTMOD)|del(.env_variables.COMMIT)' \
    | ex -sc 'wq!app.yaml' /dev/stdin
