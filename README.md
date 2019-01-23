# Kubernetes Dashboard Terraform module

Terraform module which deploy's the Kubernetes dashboard to an existing cluster.

The following Kubernetes resources are created for this deployment:

```sh
Secret
Service Account
Role
Role Binding
Deployment
Service
```

## ISSUES

Currently due to a provider issue a manual step is required after the deployment for the dashboard to work.

### Cause

The cause of the issue is the provider is unable to change the value of `automountServiceAccountToken` in the Pod, ReplicaSet or Deployment resources. The PR has been raised and is currently being reviewed for merging. [Follow Here](https://github.com/terraform-providers/terraform-provider-kubernetes/pull/261).

### Work Around

To work around this issue once the terraform is applied successfully you need to edit the deployment and change the value of `automountServiceAccountToken` to `true`.

```sh
kubectl edit deployment -n kube-system kubernetes-dashboard
```

Change the key value to `true` then save and exit the file.

```sh
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  ...
spec:
  ...
  template:
    metadata:
      ...
    spec:
      automountServiceAccountToken: true
      ...
```

## Terraform Version

Terraform version 0.11.7 or newer is required for this module to work.

## Examples

* [Simple Dashboard](https://github.com/MarvelOrange/terraform-kubernetes-dashboard/tree/master/examples/simple-dashboard)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| app_name | Application name to be labelled on all resources | string | `kubernetes-dashboard` | no |
| app_port | Dashboard container port | string | `443` | no |
| cpu_type | CPU type for the dashboard. Used to build image url https://github.com/kubernetes/dashboard/releases | string | `amd64` | no |
| dashboard_version | Dashboard version. Used to build image url https://github.com/kubernetes/dashboard/releases | string | `v1.10.0` | no |
| initial_delay_seconds | Number of seconds after the container has started before liveness probes are initiated | string | `30` | no |
| namespace | Kubernetes namespace for resources to be deployed | string | `kube-system` | no |
| replicas | Amount of pods to be deployed | string | `1` | no |
| revision_history_limit | The number of old ReplicaSets to retain to allow rollback | string | `10` | no |
| service_type | Determines how the service is exposed | string | `ClusterIP` | no |
| target_port | Dashboard target port for service exposure | string | `8443` | no |
| timeout_seconds | Number of seconds after which the liveness probe times out | string | `30` | no |

## Outputs

Currently no outputs of this module.

## Authors

Module is maintained by Ben Prudence.

## License

Apache 2 Licensed. See LICENSE for full details.
