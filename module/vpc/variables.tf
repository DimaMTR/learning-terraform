variable "instance_type" {
 description = "Type of Cloud VM instance to provision"
 default     = "e2-medium"
}

variable "instance_name" {
 description = "Name of the test VM"
 default     = "dev-vm"
}

variable "project_id" {
    description = "GCP project id"
    default = "sapient-magnet-376523"

}
variable "network_tag" {
 description = "Network tag which will be used for targeeting farewall rules"
 default     = "terraform"
}

variable "network_name" {
 description = "Network name which will be created per environemnt"
 default     = "dev-terraform-vpc"
}

variable "environment" {
    description = "Environment for running Terraform Scripts"

    type = object ({
        name           = string
        network_prefix = string
    })

    default = {
        name           = "dev"
        network_prefix = "10.10"
    }
    
}



