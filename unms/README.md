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
| image | string | `"ubnt/unms"` | UNMS docker image |
| podName | string | `"unms"` | Name of the UNMS pod |
| postgresDBname | string | `"unms"` | PostgreSQL DB name |
| postgresDBpassword | string | `"PassWord"` | PostgreSQL DB password |
| postgresDBuser | string | `"unms"` | PostgreSQL DB username |
| rbmqImage | string | `"rabbitmq:latest"` | RabitMQ docker image |
| redisImage | string | `"redis:latest"` | Redis docker image |
| replicas | int | `1` | Number of replicas |
| tag | string | `"0.10.4"` | UNMS docker tag |
| vhost | string | `"unms.domain.tld"` | Hostname used to reach UNMS |
| volumeSize | string | `"2Gi"` | UNMS storage volume size |
