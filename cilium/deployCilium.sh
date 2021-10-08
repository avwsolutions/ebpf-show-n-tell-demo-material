#!/bin/bash

# Usage: ./deployCilium.sh kube-system "1.10.4"

VERSION=$2
NAMESPACE=$1
helm upgrade --install cilium cilium/cilium --version $VERSION \
  --namespace $NAMESPACE -f cilium.aks.values.yaml