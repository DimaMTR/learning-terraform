output "instance_name" {
 value = google_compute_instance.test-vm.name
}

output "instance_id" {
 value = google_compute_instance.test-vm.instance_id
}
