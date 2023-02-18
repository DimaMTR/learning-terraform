module "test" {
    source = "../module/vpc"

    environment = {
        name           = "test"
        network_prefix = "10.11"
    }

    instance_name = "test-vm"
    network_name = "test-terraform-vpc"


}

    