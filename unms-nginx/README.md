unms-nginx
==========

## Installing the repo

```
helm repo add unms https://fastlorenzo.github.io/unms-chart/
helm repo update
```


## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"padhihomelab/unms"` |  |
| image.tag | string | `"nginx"` |  |
| ingress.annotations | object | `{"cert-manager.io/acme-challenge-type":"http01","cert-manager.io/cluster-issuer":"step-issuer","kubernetes.io/ingress.class":"nginx","nginx.ingress.kubernetes.io/backend-protocol":"HTTPS"}` | Ingress annotations |
| ingress.enabled | bool | `true` | Enable Ingress controller |
| ingress.hosts | list | `[{"host":"unms.bernardi.local","paths":["/"]}]` | Ingress hosts configuration |
| ingress.tls | list | `[{"hosts":["unms.bernardi.local"],"secretName":"unms-bernardi-local-tls"}]` | Ingress TLS configuration |
| labels | object | `{}` | unms-nginx pod extra labels |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| persistence.cert.accessModes | list | `["ReadWriteOnce"]` | UNMS storage access modes |
| persistence.cert.annotations | object | `{}` |  |
| persistence.cert.existingClaim | string | `"unms-storage-cert-nfs"` | Name of existing PVC for UNMS cert |
| persistence.cert.size | string | `"10Gi"` | UNMS storage size |
| persistence.cert.storageClass | string | `""` | UNMS PV storage class name, keep empty to use default. Not used if `existingClaim` is set. |
| persistence.enabled | bool | `false` | Persist UNMS data |
| persistence.firmwares.accessModes | list | `["ReadWriteOnce"]` | UNMS storage access modes |
| persistence.firmwares.annotations | object | `{}` |  |
| persistence.firmwares.existingClaim | string | `"unms-storage-firmwares-nfs"` | Name of existing PVC for UNMS firmwares |
| persistence.firmwares.size | string | `"10Gi"` | UNMS storage size |
| persistence.firmwares.storageClass | string | `""` | UNMS PV storage class name, keep empty to use default. Not used if `existingClaim` is set. |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| tolerations | list | `[]` |  |
