unms
====

## Installing the repo

```
helm repo add unms https://fastlorenzo.github.io/unms-chart/
helm repo update
```

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| clusterDomain | string | `"cluster.local"` | Kubernetes Cluster Domain |
| fullnameOverride | string | `""` |  |
| image | string | `"padhihomelab/unms"` | UNMS docker image name (use ubnt/unms for amd64, fastlorenzo/unms for arm/arm64) |
| imagePullPolicy | string | `"Always"` | UNMS docker image pull policy |
| imageTag | string | `"1.2.7"` | UNMS docker image tag |
| ingress.annotations | object | `{"cert-manager.io/acme-challenge-type":"http01","cert-manager.io/cluster-issuer":"step-issuer","kubernetes.io/ingress.class":"nginx","nginx.ingress.kubernetes.io/backend-protocol":"HTTPS"}` | Ingress annotations |
| ingress.enabled | bool | `false` | Enable Ingress controller |
| ingress.hosts | list | `[{"host":"unms.bernardi.local","paths":["/"]}]` | Ingress hosts configuration |
| ingress.tls | list | `[{"hosts":["unms.bernardi.local"],"secretName":"unms-bernardi-local-tls"}]` | Ingress TLS configuration |
| labels | object | `{}` | UNMS pod extra labels |
| nameOverride | string | `""` | String to partially override unms.fullname template (will maintain the release name) |
| persistence.accessModes | list | `["ReadWriteOnce"]` | UNMS storage access modes |
| persistence.annotations | object | `{}` |  |
| persistence.enabled | bool | `true` | Persist UNMS data |
| persistence.existingClaim | string | `"unms-storage-nfs"` | Name of existing PVC for UNMS data |
| persistence.size | string | `"10Gi"` | UNMS storage size |
| persistence.storageClass | string | `""` | UNMS PV storage class name, keep empty to use default. Not used if `existingClaim` is set. |
| podAnnotations | object | `{}` | Annotations for UNMS pods |
| podManagementPolicy | string | `"Parallel"` | UNMS pods management policy |
| postgresql | object | `{"existingSecret":"unms-postgresql","image":{"repository":"postgres","tag":9.6},"initdbScriptsConfigMap":"unms-unms-initdb","livenessProbe":{"initialDelaySeconds":120},"persistence":{"existingClaim":"unms-postgresql-0","mountPath":"/data","size":"20Gi"},"postgresqlDataDir":"/data/data","postgresqlDatabase":"unms","postgresqlUsername":"unms","readinessProbe":{"initialDelaySeconds":120},"resources":{"requests":{"cpu":"100m","memory":"128Mi"}},"securityContext":{"fsGroup":11001,"runAsUser":10001},"volumePermissions":{"enabled":true,"image":{"repository":"postgres","tag":9.6}}}` | Bitnami PostgreSQL values to override (source)[https://github.com/helm/charts/issues/19132] |
| postgresql.existingSecret | string | `"unms-postgresql"` | Should be RELEASE_NAME-postgresql |
| postgresql.initdbScriptsConfigMap | string | `"unms-unms-initdb"` | Should be RELEASE_NAME-unms-initdb |
| rabbitmq | object | `{"image":{"repository":"rabbitmq","tag":"3.8-alpine"},"persistence":{"enabled":false},"volumePermissions":{"image":{"repository":"rabbitmq","tag":"3.8-alpine"}}}` | Bitnami RabbitMQ values to override |
| redis | object | `{"image":{"repository":"redis","tag":6},"master":{"command":"/usr/local/bin/docker-entrypoint.sh","persistence":{"enabled":false}},"persistence":{"enabled":false},"sentinel":{"image":{"repository":"redis","tag":6}},"slave":{"command":"/usr/local/bin/docker-entrypoint.sh","persistence":{"enabled":false}},"usePassword":false,"volumePermissions":{"image":{"repository":"redis","tag":6}}}` | Bitnami Redis values to override |
| replicas | int | `1` | Number of UNMS replicas |
| resources | object | `{}` | UNMS pods resources |
| siridb | object | `{"service":{"port":9000}}` | SiriDB values to override |
| unms-nginx.ingress.annotations."cert-manager.io/acme-challenge-type" | string | `"http01"` |  |
| unms-nginx.ingress.annotations."cert-manager.io/cluster-issuer" | string | `"step-issuer"` |  |
| unms-nginx.ingress.annotations."kubernetes.io/ingress.class" | string | `"nginx"` |  |
| unms-nginx.ingress.annotations."nginx.ingress.kubernetes.io/backend-protocol" | string | `"HTTPS"` |  |
| unms-nginx.ingress.enabled | bool | `true` |  |
| unms-nginx.ingress.hosts[0].host | string | `"unms.bernardi.local"` |  |
| unms-nginx.ingress.hosts[0].paths[0] | string | `"/"` |  |
| unms-nginx.ingress.tls[0].hosts[0] | string | `"unms.bernardi.local"` |  |
| unms-nginx.ingress.tls[0].secretName | string | `"unms-bernardi-local-tls"` |  |
| unmsUserId | int | `10001` | UNMS User ID |
| updateStrategy | string | `"RollingUpdate"` | UNMS pods update strategy |
