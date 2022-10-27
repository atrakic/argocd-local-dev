#!/usr/bin/env bash

set -e
set -o pipefail

minikube delete || true
	minikube start \
		--driver=docker \
		--kubernetes-version=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt) \
		--memory=8192 \
		--bootstrapper=kubeadm \
		 --extra-config=kubeadm.node-name=minikube \
		 --extra-config=kubelet.hostname-override=minikube

## Addons:
minikube addons disable metrics-server
