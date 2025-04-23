data "digitalocean_ssh_key" "ssh-sonarqube" {
  name = var.ssh-sonarqube
  #public_key = file("~/.ssh/chave-ssh-terraform.pub")       #Irá criar a chave ssh dinamicamente. OBS.: Se realizar o Destroy do código, a chave também será destruída.
  #Não é indicado criar a chave dinamicamente quando irá usá-la em outros projetos
}