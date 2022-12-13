#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

APP=json-server

#argocd --core --server 127.0.0.1 -H "Host: argocd.mydomain.com" --plaintext --insecure \
argocd --server 127.0.0.1:8080 --insecure \
  app create "$APP" \
  --repo https://github.com/atrakic/argocd-local-dev.git \
  --path apps/json-server \
  --revision $(git branch --show-current) \
  --dest-server https://kubernetes.default.svc \
  --upsert
#  --dest-namespace "$NS" \

argocd --server 127.0.0.1:8080 app sync "$APP"

curl -i -f -L -skX GET 127.0.0.1:80 -H"Host: json-server.local"
