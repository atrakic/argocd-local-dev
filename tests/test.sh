#!/usr/bin/env bash
set -o errexit

APP=helm-guestbook

argocd --server 127.0.0.1 -H "Host: argocd.mydomain.com" --plaintext --insecure \
  app create "$APP" \
  --repo https://github.com/argoproj/argocd-example-apps.git \
  --path helm-guestbook \
  --dest-namespace default \
  --dest-server https://kubernetes.default.svc \
  --helm-set replicaCount=2

argocd --server 127.0.0.1 -H "Host: argocd.mydomain.com" --plaintext --insecure app sync "$APP"

kubectl wait --for=condition=Ready pods --all -n default --timeout=300s
