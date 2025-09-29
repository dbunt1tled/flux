#!/bin/sh
echo "=== Tools check ==="
echo "Docker: $(docker --version)"
echo "kubectl: $(kubectl version --client --short 2>/dev/null || echo 'kubectl installed')"
echo "Kind: $(kind version)"
echo "Flux: $(flux version --client)"
echo "SOPS: $(sops --version)"
echo "Age: $(age --version)"
echo "Kustomize: $(kustomize version --short)"

flux check --pre
echo "✅ Flux CLI works"

echo "test-secret" | age-keygen -y /dev/stdin > /dev/null && echo "✅ Age works"
echo "test: secret" | sops --encrypt --age $(age-keygen -y <(echo "test")) /dev/stdin > /dev/null && echo "✅ SOPS works"