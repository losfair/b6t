#!/bin/bash

set -e

if [ -z "$RUST_LOG" ]; then
  export RUST_LOG=info
fi

export AWS_ACCESS_KEY_ID="minioadmin"
export AWS_SECRET_ACCESS_KEY="minioadmin"

exec /usr/bin/blueboat_server -l "0.0.0.0:3000" \
  --s3-bucket "apps" --s3-region "us-east-1" \
  --s3-endpoint "http://localhost:1932" \
  --mds ws://localhost:2999/b --mds-local-region "local"
