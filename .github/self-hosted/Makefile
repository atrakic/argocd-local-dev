# Self-hosting with minikube

MAKEFLAGS += --silent

.PHONY: all clean setup install-argocd

all:
	echo ""
	echo "::URL       'http://localhost:8080'"
	echo "::LOGIN     'admin'"
	echo "::PASSWORD  $$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d)"

setup:
	echo "You are about to create demo cluster."
	echo "Are you sure? (Press Enter to continue or Ctrl+C to abort) "
	read _
	./$@.sh

install-argocd:
	./$@.sh
	killall kubectl || kubectl port-forward svc/argocd-server -n argocd 8080:443 &

clean:
	./$@.sh

-include include.mk
