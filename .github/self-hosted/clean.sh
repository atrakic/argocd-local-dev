#!/usr/bin/env bash

set -e
set -o pipefail

minikube delete || true
