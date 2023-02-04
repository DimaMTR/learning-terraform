variable "instance_type" {
 description = "Type of Cloud VM instance to provision"
 default     = "e2-medium"
}

variable "instance_name" {
 description = "Name of the test VM"
 default     = "dummy-vm"
}

variable "network_tag" {
 description = "Network tag which will be used for targeeting farewall rules"
 default     = "terraform"
}



