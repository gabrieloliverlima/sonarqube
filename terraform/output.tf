
output "droplet_ip" {
  value = digitalocean_droplet.sonarqube.ipv4_address
}