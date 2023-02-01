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

resource "google_compute_firewall" "nodejs-server"{
  name        = "nodejs-server"
  description = "Allow to access VM from public IPs"
  
  network     = data.google_compute_network.default.name

  rules       = [
    google_compute_firewall_policy_rule.nodejs-http-in.self_link,
    google_compute_firewall_policy_rule.nodejs-http-out.self_link,
  ]
}

resource "google_compute_firewall_policy_rule" "nodejs-http-in" {
  action = "ALLOW"
  direction = "INGRESS"
  priority = 10

  match {
    layer4_config {
      all = true
    }
  }

}

resource "google_compute_firewall_policy_rule" "nodejs-http-out" {
  action   = "ALLOW"
  priority = 10
  match {
    layer4_config {
      all = true
    }
  }

  direction = "EGRESS"
}

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

  connection {
    type        = "ssh"
    host        = self.network_interface.0.access_config.0.nat_ip
    user        = "root"
    private_key = file("~/.ssh/id_rsa")
  }

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
