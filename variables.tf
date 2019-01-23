## Global Variables
variable "app_name" {
  default     = "kubernetes-dashboard"
  description = "Application name to be labelled on all resources"
}

variable "namespace" {
  default     = "kube-system"
  description = "Kubernetes namespace for resources to be deployed"
}

variable "target_port" {
  default     = 8443
  description = "Dashboard target port for service exposure"
}

## Service Variables
variable "app_port" {
  default     = 443
  description = "Dashboard container port"
}

variable "service_type" {
  default     = "ClusterIP"
  description = "Determines how the service is exposed"
}

## Deployment Variables
variable "replicas" {
  default     = 1
  description = "Amount of pods to be deployed"
}

variable "revision_history_limit" {
  default     = 10
  description = "The number of old ReplicaSets to retain to allow rollback"
}

variable "cpu_type" {
  default     = "amd64"
  description = "CPU type for the dashboard. Used to build image url https://github.com/kubernetes/dashboard/releases"
}

variable "dashboard_version" {
  default     = "v1.10.0"
  description = "Dashboard version. Used to build image url https://github.com/kubernetes/dashboard/releases"
}

variable "initial_delay_seconds" {
  default     = 30
  description = "Number of seconds after the container has started before liveness probes are initiated"
}

variable "timeout_seconds" {
  default     = 30
  description = "Number of seconds after which the liveness probe times out"
}
