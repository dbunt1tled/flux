# FluxCD GitOps Repository

This repository contains Kubernetes configurations for deploying applications using FluxCD in a GitOps workflow. It's designed to manage Kubernetes clusters and applications in a declarative way using Git as the single source of truth.

## 📋 Project Structure

```
.
├── apps/                 # Application configurations
│   ├── base/            # Base application configurations
│   └── production/      # Production environment overrides
├── clusters/            # Cluster-specific configurations
│   └── production/      # Production cluster configuration
├── infrastructure/      # Infrastructure components
│   ├── configs/         # Configuration files
│   ├── controllers/     # Kubernetes controllers (e.g., ingress-nginx)
│   ├── image-automation/ # Image update automation
│   └── namespaces/      # Namespace definitions
├── secrets/             # Encrypted secrets using SOPS
├── .sops.yaml           # SOPS configuration
└── kind-config.yaml     # Local Kubernetes cluster configuration
```

## 🚀 Prerequisites

- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Flux CLI](https://fluxcd.io/docs/installation/)
- [SOPS](https://github.com/mozilla/sops) (for secret management)
- [age](https://github.com/FiloSottile/age) (for encryption)
- [kind](https://kind.sigs.k8s.io/) (for local development)

## 🛠️ Setup

### 1. Bootstrap FluxCD

```bash
# Install Flux CLI (macOS)
brew install fluxcd/tap/flux

# Verify Flux prerequisites
flux check --pre

# Bootstrap Flux in your cluster
flux bootstrap git \
  --url=git@github.com:your-username/flux-cd-test.git \
  --branch=main \
  --path=./clusters/production
```

### 2. Set Up Secrets Encryption

1. Generate an age key pair if you don't have one:
   ```bash
   age-keygen -o age.agekey
   ```

2. Create a Kubernetes secret with the private key:
   ```bash
   kubectl create secret generic sops-age \
     --from-file=age.agekey=.sops-key/age.agekey \
     -n flux-system
   ```

3. Encrypt a secret file:
   ```bash
   sops --age=<your-public-key> \
        --encrypt \
        --encrypted-regex '^(data|stringData)$' \
        --in-place secrets/production/your-secret.yaml
   ```

## 🏗️ Application Deployment

Applications are defined in the `apps/` directory with a base configuration and environment-specific overrides. The production environment is configured in `clusters/production/apps.yaml`.

### Adding a New Application

1. Create a new directory in `apps/base/` for your application
2. Add Kubernetes manifests (deployment, service, etc.)
3. Create a `kustomization.yaml` file
4. Reference the application in `clusters/production/apps.yaml`

## 🔄 GitOps Workflow

1. **Make changes** to the repository
2. **Commit and push** to the main branch
3. **Flux detects** the changes and applies them to the cluster
4. **Monitor** the sync status:
   ```bash
   flux get kustomizations --watch
   ```

## 🔒 Security

- All secrets are encrypted with SOPS using age
- Access to the repository should be restricted
- Use branch protection rules in GitHub
- Regularly rotate encryption keys

## 🌐 Ingress Configuration

This repository includes configurations for:
- Ingress-NGINX controller
- TLS certificate management
- Domain routing rules

## Local Run

```bash
    kubectl port-forward -n flux-system svc/loki-stack-grafana 3000:80
    kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 8080:80
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📚 Resources

- [FluxCD Documentation](https://fluxcd.io/docs/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [SOPS Documentation](https://github.com/mozilla/sops)