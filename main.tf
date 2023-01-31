# data "aws_ami" "app_ami" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["979382823631"] # Bitnami
# }

# resource "aws_instance" "web" {
#   ami           = data.aws_ami.app_ami.id
#   instance_type = "t3.nano"

#   tags = {
#     Name = "HelloWorld"
#   }
# }

resource "google_compute_instance" "test-vm" {
  name         = "test-vm"
  machine_type = var.instance_type
  zone         = "us-west1-b"

  tags = ["hello-world"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        os = "debian"
      }
    }
  }
  network_interface {
    network = "default"
  }
}
