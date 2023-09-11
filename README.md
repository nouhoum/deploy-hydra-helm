Install PG in minikube:

```sh
helm install pg-minikube --set auth.postgresPassword=pgpassword bitnami/postgresql
```

The created database is "postgres" with the password "pgpassword". Database has the host pg-minikube-postgresql.default.svc.cluster.local

## Secrets needed by Hydra

```sh
kubectl create secret generic hydra \
--from-literal=dsn=postgresql://postgres:pgpassword@pg-minikube-postgresql.default.svc.cluster.local:5432/postgres \
    --from-literal=secretsCookie=$(LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | base64 | head -c 32) \
    --from-literal=secretsSystem=$(LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | base64 | head -c 32)
```

Check helm files:

```sh
helm lint ./deploy/helm/hydra
helm template ./deploy/helm/hydra
```

Install the package

```sh
helm install hydra ./deploy/helm/hydra -f ./deploy/helm/hydra/values.yaml
```
