###########################
# Kubernetes Provider Setup
###########################
provider "kubernetes" {}

#################################
# Kubernetes Dashboard Deployment
#################################
module "dashboard_example_simple-dashboard" {
  source  = "MarvelOrange/dashboard/kubernetes"
  version = "0.1.0"
}
