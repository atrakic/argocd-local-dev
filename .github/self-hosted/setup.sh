#!/usr/bin/env bash

set -e
set -o pipefail

minikube delete || true

docker network rm minikube || true
#docker network create --driver=bridge --subnet=172.28.0.0/16 --gateway=172.28.0.1 minikube

minikube start \
  --driver=docker \
  --kubernetes-version="$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)" \
  --memory=8192 \
  --bootstrapper=kubeadm \
  --extra-config=kubeadm.node-name=minikube \
  --extra-config=kubelet.hostname-override=minikube
  #--network minikube \

## Addons:
minikube addons disable metrics-server


example::ingress() {
  minikube addons enable ingress
  minikube addons enable ingress-dns
  #minikube tunnel &
  kubectl create deployment web --image=gcr.io/google-samples/hello-app:1.0
  kubectl expose deployment web --type=NodePort --port=8080
  cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$1
spec:
  rules:
    - host: hello-world.info
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: web
                port:
                  number: 8080
EOF
}
