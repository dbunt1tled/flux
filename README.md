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

Добавить в кластер ключ 
kubectl create secret generic sops-age --from-file=age.agekey=.sops-key/age.agekey -n flux-system
secret/sops-age created