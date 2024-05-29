#!/usr/bin/env bash

#   (`-')           (`-').->
#   ( OO).->        (OO )__
# ,(_/----. .----. ,--. ,'-' doubt everything,
# |__,    |\_,-.  ||  | |  |
#  (_/   /    .' .'|  `-'  | be curious,
#  .'  .'_  .'  /_ |  .-.  |
# |       ||      ||  | |  | learn.
# `-------'`------'`--' `--'

if ! command -v zola &> /dev/null; then
  echo "Can; git zola kur!"
  exit 1
fi

zola build

if [[ -z "$VG_S3_BUCKET" || -z "$VG_DISTRIBUTION_ID" ]]; then
  echo "Error: VG_S3_BUCKET and VG_DISTRIBUTION_ID must be set."
  exit 1
fi

aws s3 sync public/ "$VG_S3_BUCKET"

aws cloudfront create-invalidation --distribution-id "$VG_DISTRIBUTION_ID" --paths "/*"
