# Install HA Infisical with Posgresql & Redis

### Pre-Requisites
1. [`cloudnative-pg`](https://cloudnative-pg.io/documentation/current/) operator installed
2. [`longhorn`](https://longhorn.io/docs/1.8.1/) storage class (Can be any storage class of choice)
3. [`traefik` with `IngresRoutes` and wildcard tls certificate of your domain (Can be loadBalancer and reverse-proxy of choise)](https://technotim.live/posts/kube-traefik-cert-manager-le/)
4. [Self-signed certificate issuer CA](https://github.com/chakraborty29/Home-Lab/tree/develop/templates/k3s/cert-manager)
5. `bitnami` helm charts installed
6. The custom `infisical-standalone/` in this dir with the chart templates updated to allow for secure TLS connection for Posgres

### Create Namespace for Infisical
```
kubectl create ns infisical
```

### Apply StorageClass
```
kubectl apply -f storage/
```

### Apply Secrets
```
kubectl apply -f secrets/
```

### Apply certificates
```
kubectl apply -f certificates/
```

### Create HA Postgres from `cloudnative-pg`
```
# Create Cluster
kubectl apply -f postgres/cluster.yaml

# Create a Scheduled Backup of Cluster
kubectl apply -f scheduled-backup.yaml

# IMPORTANT - Create the pg-infisical databse - Migration will fail if the database is not created before hand
kubectl apply -f postgres/pg-infisical.yaml
```

### Deploy Redis with Helm
```
helm install redis-infisical bitnami/redis --namespace infisical --values redis/values.yaml
```

### Deploy Infisical with Helm
```
helm install infisical ./infisical-standalone --namespace infisical -f values.yaml
```

### Apply `IngressRoute` for Infisical
```
kubectl apply -f ingress.yaml
```
