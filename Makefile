MAKEFLAGS += --silent

.DEFAULT_GOAL := help

all: ## Bootstrap
	kind create cluster --config config/kind.yaml --wait 60s || true
	scripts/ingress/up.sh
	scripts/argocd/up.sh
	#kubectl apply -f config/argocd-ingress.yaml

status: ## Status
	kubectl cluster-info
	argocd app list

port_forward: ## Port forward
	scripts/argocd/port_forward.sh

load_image: ## Load busybox image
	docker pull busybox
	kind load docker-image busybox

clean: ## Clean
	kind delete cluster

test: ## Test app
	[ -f ./tests/test.sh ] && ./tests/test.sh

help:  ## Display this help menu
	awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: help test clean sync status

-include include.mk
