# FluxCD GitOps Repository

Этот репозиторий содержит Kubernetes конфигурации для развертывания приложения с использованием FluxCD.

## Структура
- `clusters/` - конфигурация кластеров
- `infrastructure/` - базовые компоненты (ingress, cert-manager, monitoring)
- `apps/` - приложения
- `secrets/` - зашифрованные секреты

## Использование
1. Убедитесь что FluxCD установлен в кластере
2. Все секреты зашифрованы с помощью SOPS
3. Изменения применяются автоматически через Git commits

# SOPS - AGE

## Add Private key to Cluster

kubectl create secret generic sops-age --from-file=age.agekey=.sops-key/age.agekey -n flux-system
secret/sops-age created

## Encrypt

sops --age=age1vn0qveeefceqjx26373f2kcqeva8yw92jyttd8hafwcse2twldxs0lcn4c --encrypt --encrypted-regex '^(data|stringData)$'--in-place secrets/production/test-secret.yaml