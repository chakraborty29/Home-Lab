# Install cert-manager for self-signed certificates and root self-signed CA

### Pre-Requisites
1. `helm` installed on host machine

### Create Namespace for cert-manager
```
kubectl create ns cert-manager
```

### Apply cert-manager CRDs
```
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.17.1/cert-manager.crds.yaml
```
### Deploy cert-manager with helm
```
helm install cert-manager jetstack/cert-manager --namespace cert-manager --values=values.yaml --version v1.17.1
```

### Create self-signed issuer
```
kubectl apply -f issuers/internal/self-signed.yaml
```

### Create self-signed root CA
```
kubectl apply -f certificates/internal/self-signed-ca.yaml
```

### Create a new issuer with this CA (Global Root Certificate for Cluster for easier management)
```
kubectl apply -f issuers/internal/self-signed-ca-issuer.yaml
```

### Create new certificates with this issuer
```
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: self-signed-tls-certificate
spec:
  secretName: self-signed-tls
  duration: 8760h # 1 year
  renewBefore: 720h # 30 days
  dnsNames: 
    - service.namespace.svc.cluster.local
    - *.namespace.svc.cluster.local
    - *.svc.cluster.local
    - *.cluster.local
  issuerRef:
    name: self-signed-ca-issuer
    kind: ClusterIssuer
```
