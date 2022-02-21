module "vpc" {
  source       = "github.com/terraform-google-modules/terraform-google-network"
  project_id   = var.project_id
  network_name = "tap-vpc-${var.environment}"
  subnets = [{
    subnet_name   = "subnet-01"
    subnet_ip     = "10.0.0.0/16"
    subnet_region = var.region
  }]
  secondary_ranges = {
    subnet-01 = [{
      range_name    = "subnet-01-secondary-01"
      ip_cidr_range = "10.10.0.0/16"
      }, {
      range_name    = "subnet-01-secondary-02"
      ip_cidr_range = "10.20.0.0/16"
    }]
  }
}

module "jumphost" {
  name          = "tap-jumphost-${var.environment}"
  source        = "terraform-google-modules/bastion-host/google"
  project       = var.project_id
  zone          = var.zones[0]
  network       = module.vpc.network_name
  subnet        = module.vpc.subnets_names[0]
  image_family  = "ubuntu-2110"
  image_project = "ubuntu-os-cloud"
  ephemeral_ip  = true
  startup_script = file("startup.sh")
}


resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = var.project_id
  name                       = "tap-cluster-${var.environment}"
  region                     = var.region
  regional                   = true
  network                    = module.vpc.network_name
  subnetwork                 = module.vpc.subnets_names[0]
  ip_range_pods              = "subnet-01-secondary-01"
  ip_range_services          = "subnet-01-secondary-02"
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  network_policy             = false
  remove_default_node_pool   = true
  cluster_autoscaling = {
    enabled       = false
    max_cpu_cores = 0
    min_cpu_cores = 0
    max_memory_gb = 0
    min_memory_gb = 0
    gpu_resources = []
  }
  node_pools = [
    {
      name                   = "default-node-pool"
      machine_type           = "e2-standard-4"
      node_locations         = join(",", var.zones)
      min_count              = 1
      max_count              = 1
      local_ssd_count        = 0
      disk_size_gb           = 100
      disk_type              = "pd-standard"
      image_type             = "COS_CONTAINERD"
      auto_repair            = true
      auto_upgrade           = true
      create_service_account = true
      service_account        = "service-account-id@${var.project_id}.iam.gserviceaccount.com"
      preemptible            = false
      autoscaling            = true
      initial_node_count     = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = []
    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}
    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}
    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []
    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []
    default-node-pool = [
      "default-node-pool",
    ]
  }
}
