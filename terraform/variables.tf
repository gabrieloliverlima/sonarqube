variable "do_token" {
  type        = string
  description = "Token da API da Digital Ocean"
}

variable "droplet_name" {
  default     = "sonarqube"
  type        = string
  description = "Nome inicial do Droplet"
}

variable "droplet_region" {
  default     = "nyc1"
  type        = string
  description = "Região do Droplet"
}

variable "droplet_size" {
  default     = "s-2vcpu-2gb"
  type        = string
  description = "Perfil dos Droplets"
}

variable "ssh-sonarqube" {
  default     = "ssh-sonarqube"
  type        = string
  description = "Chave SSH Droplet"
}

