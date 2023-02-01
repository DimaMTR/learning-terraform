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


data "google_compute_network" "default" {
  name = "default"
}

resource "google_compute_firewall" "http-rule-in"{ 
  name        = "http-rule-in"
  description = "Allow to access VM from public IPs"
  
  network     = data.google_compute_network.default.name
  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  allow {
    
    protocol = "tcp"
    ports = [443, 443] 
  }
}

resource "google_compute_firewall" "http-rule-out"{ 
  name        = "http-rule-out"
  description = "Allow to access Anything outside"
  
  network     = data.google_compute_network.default.name
  direction = "EGRESS"
  destination_ranges  = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = ["80","80"]
  }
}

# resource "google_compute_firewall_policy" "default" {
#   parent      = "organizations/sapient-magnet-376523"
#   short_name  = "allow-all-traffic"
#   description = "Example Resource"
# }

# resource "google_compute_firewall_policy_rule" "nodejs-http-in" {
#   firewall_policy = google_compute_firewall_policy.default.id
#   action = "ALLOW"
#   direction = "INGRESS"
#   priority = 10

#   match {
#     layer4_configs {
#       ip_protocol = "tcp"
#       ports = [443, 443]
#     }
#     src_ip_ranges = "0.0.0.0/0"
#   }

# }

# resource "google_compute_firewall_policy_rule" "nodejs-http-out" {
#   firewall_policy = google_compute_firewall_policy.default.id
#   action    = "ALLOW"
#   priority  = 10
#   direction = "EGRESS"
#   match {
#     layer4_configs {
#       ip_protocol = "tcp"
#       ports = [80, 80]
#     }
#     dest_ip_ranges = "0.0.0.0/0"
#   }
# }

resource "google_compute_instance" "nodejs-server" {
  name         = var.instance_name
  machine_type = var.instance_type
  zone         = "us-west1-b"

  tags = ["hello-world"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  # connection {
  #   type        = "ssh"
  #   host        = self.network_interface.0.access_config.0.nat_ip
  #   user        = "root"
  #   private_key = file("~/.ssh/id_rsa")
  # }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nodejs",
      "sudo apt-get install -y npm",
      "sudo npm install -g express",
      "echo 'const express = require(\"express\");\nconst app = express();\napp.get(\"/\", (req, res) => {\n res.send(\"Hello from Node.js!\");\n});\napp.listen(3000, () => {\n console.log(\"Node.js server is listening on port 3000\");\n});' > app.js",
      "sudo node app.js &"
    ]
  }

  network_interface {
    network = data.google_compute_network.default.name
  }
}
