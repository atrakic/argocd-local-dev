#!/usr/bin/env bash

set -e
set -o pipefail

NS=argocd

kubectl create namespace "$NS" || true
kubectl apply -n "$NS" -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl wait --for=condition=available deployment -l "app.kubernetes.io/name=argocd-server" -n "$NS" --timeout=600s
kubectl wait --for=condition=available deployment argocd-repo-server -n "$NS" --timeout=60s
kubectl wait --for=condition=available deployment argocd-dex-server -n "$NS" --timeout=60s

# disable TLS on argocd server
kubectl -n "$NS" patch deployment argocd-server --type json \
  -p='[ { "op": "replace", "path":"/spec/template/spec/containers/0/command","value": ["argocd-server","--staticassets","/shared/app","--insecure"] }]'

# enable ingress:
cat <<EOF | kubectl -n "$NS" apply -f -
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-server-http-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$1
    nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
spec:
  ingressClassName: nginx
  rules:
    - host: argocd.mydomain.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: argocd-server
                port:
                  number: 80
EOF
