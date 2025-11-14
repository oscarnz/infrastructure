provider "digitalocean" {}

##------------------------------------------------
## VPC module call
##------------------------------------------------
module "vpc" {
  source      = "terraform-do-modules/vpc/digitalocean"
  version     = "1.0.0"
  name        = "k8s-do-sg-3"
  environment = "development"
  region      = "sgp1"
  ip_range    = "10.20.0.0/16"
}

##------------------------------------------------
## Kubernetes module call
##------------------------------------------------
module "cluster" {
  source          = "terraform-do-modules/kubernetes/digitalocean"
  name            = "k8s-do-sg-4"
  environment     = "development"
  region          = "sgp1"
  cluster_version = "1.33.1-do.5"
  vpc_uuid        = module.vpc.id

  app_node_pools = {
    app_node = {
      size       = "s-2vcpu-4gb"
      node_count = 3
      min_nodes  = 3
      max_nodes  = 3
    }
  }
}
