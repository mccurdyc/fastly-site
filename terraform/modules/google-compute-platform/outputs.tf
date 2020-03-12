output "load_balancer_ip_address" {
  description = "The IP address of the Cloud Load Balancer."
  value       = google_compute_global_address.default.address
}

output "dns_name_servers" {
  description = "The DNS name servers."
  value       = google_dns_managed_zone.dev.name_servers
}
