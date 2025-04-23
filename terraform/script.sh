#!/bin/bash
# Define modo não interativo para evitar prompts
export DEBIAN_FRONTEND=noninteractive

# Atualiza pacotes
apt-get update -y && apt-get upgrade -y

# Instala pacotes necessários para usar o repositório Docker
apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release unzip

# Adiciona chave GPG do Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Adiciona repositório do Docker
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instala Docker Engine
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

# Habilita e inicia Docker
systemctl enable docker
systemctl start docker

# Instala Docker Compose (versão 2.x)
DOCKER_COMPOSE_VERSION="2.24.1"
curl -SL "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Configura vm.max_map_count
sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" >> /etc/sysctl.conf
sysctl -p

# Cria diretório para o SonarQube no /root
mkdir -p /root/sonarqube
cd /root/sonarqube

# Cria arquivo docker-compose.yml
cat <<EOF > docker-compose.yml
version: "3"

services:
  sonarqube:
    image: sonarqube:lts-community
    depends_on:
      - db
    networks:
      - sonar_net
    environment:
      SONAR_JDBC_URL: jdbc:postgresql://db:5432/sonar
      SONAR_JDBC_USERNAME: sonar
      SONAR_JDBC_PASSWORD: sonar
    ports:
      - "9000:9000"
    volumes:
      - sonar_data:/opt/sonarqube/data
      - sonar_logs:/opt/sonarqube/logs

  db:
    image: postgres:15
    environment:
      POSTGRES_USER: sonar
      POSTGRES_PASSWORD: sonar
      POSTGRES_DB: sonar
    networks:
      - sonar_net
    volumes:
      - sonar_db:/var/lib/postgresql

networks:
  sonar_net:
    driver: bridge
volumes:
  sonar_data:
  sonar_logs:
  sonar_db:
EOF

# Sobe o container
docker compose up -d

echo "✅ Instalação concluída. SonarQube disponível na porta 9000"
