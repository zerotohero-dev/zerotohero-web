#!/usr/bin/env bash

#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

rm -rf public

container_id=$(docker ps --filter "ancestor=z2h:latest" --format "{{.ID}}")

if [ -n "$container_id" ]; then
  docker cp "$container_id":/public "$(pwd)"

  echo "Files copied from container ID $container_id to $(pwd)/public"
else
  echo "No running container found for image z2h:latest"
fi

if [[ -z "$VG_S3_BUCKET" || -z "$VG_DISTRIBUTION_ID" ]]; then
  echo "Error: VG_S3_BUCKET and VG_DISTRIBUTION_ID must be set."
  exit 1
fi

aws s3 sync public/ "$VG_S3_BUCKET"

aws cloudfront create-invalidation --distribution-id "$VG_DISTRIBUTION_ID" --paths "/*"
