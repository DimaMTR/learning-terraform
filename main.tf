
resource "google_compute_instance" "nodejs-server" {
  name         = var.instance_name
  machine_type = var.instance_type
  zone         = "us-west1-b"

  tags = [var.network_tag]
  
  labels = {
        vm_type = "terraform-vm"
      }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    network = var.terraform_vpc.network_name
  }
}

module "terraform-vpc" {
    source  = "terraform-google-modules/network/google"
    version = "~> 6.0"

    project_id   = var.project_id
    network_name = "terraform-vpc"
    routing_mode = "GLOBAL"
    description  = "This is a VPC created just for demonstrating abilities of terraform"

    subnets = [
        {
            subnet_name           = "terraform-vpc-subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = "us-west1"
            description           = "This is a first subnet for the terraform learning"
        },
        {
            subnet_name           = "terraform-vpc-subnet-02"
            subnet_ip             = "10.10.20.0/24"
            subnet_region         = "us-west1"
            subnet_private_access = "true"
            subnet_flow_logs      = "true"
            description           = "This is a SECOND subnet for the terraform learning"
        }
    ]
}

resource "google_compute_firewall" "http-rule-in"{ 
  name          = "http-rule-in"
  description   = "Allow to access VM from public IPs"
  
  network       = var.terraform_vpc.network_name
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = [443, 443] 
  }

  target_tags   = [var.network_tag]
}

resource "google_compute_firewall" "http-rule-out"{ 
  name        = "http-rule-out"
  description = "Allow to access Anything outside"
  
  network     = var.terraform_vpc.network_name
  direction = "EGRESS"
  destination_ranges  = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = ["80","80"]
  }
  
  target_tags   = [var.network_tag]
}
