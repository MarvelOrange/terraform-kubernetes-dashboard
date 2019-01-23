###########################
# Kubernetes Provider Setup
###########################
provider "kubernetes" {}

#################################
# Kubernetes Dashboard Deployment
#################################
module "kubernetes_dashboard" {
  source = "../../"
}
