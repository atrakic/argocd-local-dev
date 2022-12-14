#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

APP="$1"

kubectl create namespace $APP || true
#argocd --core --server 127.0.0.1 -H "Host: argocd.mydomain.com" --plaintext --insecure \
argocd --server 127.0.0.1:8080 --insecure \
  app create "$APP" \
  --repo https://github.com/atrakic/argocd-local-dev.git \
  --path apps/json-server \
  --revision $(git branch --show-current) \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace $APP \
  --upsert

argocd --server 127.0.0.1:8080 app sync "$APP"
argocd --server 127.0.0.1:8080 app wait "$APP"
