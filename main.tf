terraform {
  required_version = ">= 0.11.7"
}

########
# Secret
########
resource "kubernetes_secret" "dashboard" {
  metadata {
    name      = "${var.app_name}-certs"
    namespace = "${var.namespace}"

    labels {
      k8s-app = "${var.app_name}"
    }
  }

  type = "Opaque"
}

#################
# Service Account
#################
resource "kubernetes_service_account" "dashboard" {
  metadata {
    name      = "${var.app_name}"
    namespace = "${var.namespace}"

    labels {
      k8s-app = "${var.app_name}"
    }
  }

  automount_service_account_token = true
}

######
# Role
######
resource "kubernetes_role" "dashboard" {
  metadata {
    name      = "${var.app_name}-minimal"
    namespace = "${var.namespace}"
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["create"]
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["create"]
  }

  rule {
    api_groups     = [""]
    resources      = ["secrets"]
    resource_names = ["${var.app_name}-key-holder", "${var.app_name}-certs"]
    verbs          = ["get", "update", "delete"]
  }

  rule {
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["${var.app_name}-settings"]
    verbs          = ["get", "update"]
  }

  rule {
    api_groups     = [""]
    resources      = ["services"]
    resource_names = ["heapster"]
    verbs          = ["proxy"]
  }

  rule {
    api_groups     = [""]
    resources      = ["services/proxy"]
    resource_names = ["heapster", "http:heapster:", "https:heapster:"]
    verbs          = ["get"]
  }
}

##############
# Role Binding
##############
resource "kubernetes_role_binding" "dashbaord" {
  metadata {
    name      = "${var.app_name}-minimal"
    namespace = "${var.namespace}"
  }

  role_ref {
    name      = "${var.app_name}-minimal"
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
  }

  subject {
    name      = "${var.app_name}"
    namespace = "${var.namespace}"
    kind      = "ServiceAccount"
    api_group = ""
  }
}

############
# Deployment
############
resource "kubernetes_deployment" "dashboard" {
  metadata {
    name      = "${var.app_name}"
    namespace = "${var.namespace}"

    labels {
      k8s-app = "${var.app_name}"
    }
  }

  spec {
    replicas               = "${var.replicas}"
    revision_history_limit = "${var.revision_history_limit}"

    selector {
      match_labels {
        k8s-app = "${var.app_name}"
      }
    }

    template {
      metadata {
        namespace = "${var.namespace}"

        labels {
          k8s-app = "${var.app_name}"
        }
      }

      spec {
        container {
          name  = "${var.app_name}"
          image = "k8s.gcr.io/kubernetes-dashboard-${var.cpu_type}:${var.dashboard_version}"

          port {
            container_port = "${var.target_port}"
            protocol       = "TCP"
          }

          args = [
            "--auto-generate-certificates",
          ]

          volume_mount {
            name       = "${var.app_name}-certs"
            mount_path = "/certs"
          }

          volume_mount {
            name       = "tmp-volume"
            mount_path = "/tmp"
          }

          liveness_probe {
            http_get {
              scheme = "HTTPS"
              path   = "/"
              port   = "${var.target_port}"
            }

            initial_delay_seconds = "${var.initial_delay_seconds}"
            timeout_seconds       = "${var.timeout_seconds}"
          }
        }

        volume {
          name = "${var.app_name}-certs"

          secret {
            secret_name = "${var.app_name}-certs"
          }
        }

        volume {
          name      = "tmp-volume"
          empty_dir = [{}]
        }

        service_account_name = "${var.app_name}"
      }
    }
  }
}

#########
# Service
#########
resource "kubernetes_service" "dashboard" {
  metadata {
    name      = "${var.app_name}"
    namespace = "${var.namespace}"

    labels {
      k8s-app = "${var.app_name}"
    }
  }

  spec {
    port {
      port        = "${var.app_port}"
      target_port = "${var.target_port}"
    }

    type = "${var.service_type}"

    selector {
      k8s-app = "${var.app_name}"
    }
  }
}
