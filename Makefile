MAKEFLAGS += --silent

.DEFAULT_GOAL := help

APP := json-server

all: kind setup load_image port_forward test status ## Do all

kind: ## kinD
	kind create cluster --config config/kind.yaml --wait 60s || true

setup:
	scripts/ingress/up.sh
	scripts/argocd/up.sh

status: ## Status
	argocd --server 127.0.0.1:8080 app list

sync deploy: login ## Deploy and sync
	scripts/argocd/deploy.sh $(APP)

port_forward: ## Port forward
	scripts/argocd/port_forward.sh &
	sleep 1

load_image: ## Load image under test
	docker pull adtrdr/json-server-app:latest
	kind load docker-image adtrdr/json-server-app:latest

login: ## ArgoCD Login
	scripts/argocd/login.sh

test: sync ## Test app
	[ -f ./tests/test.sh ] && ./tests/test.sh $(APP)

clean: ## Clean
	kind delete cluster

help:  ## Display this help menu
	awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: help clean test sync login load_image status kind all

-include include.mk
