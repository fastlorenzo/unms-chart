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
| DBSize | string | `"10Gi"` | PostgreSQL storage volume size |
| DBimage | string | `"postgres:latest"` | PostgreSQL docker image |
| clusterDomain | string | `"cluster.local"` | K8S cluster domain name |
| postgresDBname | string | `"unms"` | PostgreSQL DB name |
| postgresDBpassword | string | `"PassWord"` | PostgreSQL DB password |
| postgresDBuser | string | `"unms"` | PostgreSQL DB username |
| rbmqImage | string | `"rabbitmq:latest"` | RabitMQ docker image |
| redisImage | string | `"redis:latest"` | Redis docker image |
| unms.image | string | `"ubnt/unms"` | UNMS docker image name |
| unms.imagePullPolicy | string | `"IfNotPresent"` | UNMS docker image pull policy |
| unms.imageTag | string | `"0.10.4"` | UNMS docker image tag |
| unms.labels | object | `{}` | UNMS pod extra labels |
| unms.persistence.accessModes | list | `["ReadWriteMany"]` | UNMS storage access modes |
| unms.persistence.annotations | object | `{}` |  |
| unms.persistence.enabled | bool | `true` | Persist UNMS data |
| unms.persistence.existingClaim | string | `""` | Name of existing PVC for UNMS data |
| unms.persistence.size | string | `"2Gi"` | UNMS storage size |
| unms.persistence.storageClass | string | `""` | UNMS PV storage class name, keep empty to use default. Not used if `existingClaim` is set. |
| unms.podAnnotations | object | `{}` | Annotations for UNMS pods |
| unms.replicas | int | `1` | Number of UNMS replicas |
| unms.resources | object | `{}` | UNMS pods resources |
| vhost | string | `"unms.domain.tld"` | Hostname used to reach UNMS |
| volumeSize | string | `"2Gi"` | UNMS storage volume size |
