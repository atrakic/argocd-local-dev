#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

APP="$1"

curl -i -f -L -skX GET 127.0.0.1:80 -H"Host: $APP.local"
