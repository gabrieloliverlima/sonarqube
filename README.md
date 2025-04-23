# 🔍 SonarQube + PostgreSQL com Docker e Terraform na DigitalOcean

Este repositório tem como objetivo criar um ambiente completo com **SonarQube** e **PostgreSQL**, que pode ser executado:

- Localmente com **Docker Compose**
- Em nuvem na **DigitalOcean** com **Terraform**

> 📹 Projeto baseado no vídeo [“Instalando e Configurando o SonarQube com Docker Compose”](https://www.youtube.com/watch?v=HSFHgti6nXg), publicado no meu canal no YouTube.

---

## 🐳 Parte 1: Executando localmente com Docker Compose

### ✅ Serviços Criados

- **SonarQube**: Ferramenta para análise contínua de código.
- **PostgreSQL**: Banco de dados utilizado pelo SonarQube.

### ⚙️ Variáveis de Ambiente

- **SonarQube**:
  - `SONAR_JDBC_URL`
  - `SONAR_JDBC_USERNAME`
  - `SONAR_JDBC_PASSWORD`

- **PostgreSQL**:
  - `POSTGRES_USER`
  - `POSTGRES_PASSWORD`
  - `POSTGRES_DB`

### 💾 Volumes

- `sonar_data`: Armazena dados do SonarQube
- `sonar_logs`: Armazena logs do SonarQube
- `sonar_db`: Armazena dados do PostgreSQL

### ▶️ Instruções

1. Certifique-se de ter o Docker e Docker Compose instalados.
2. No diretório do projeto, execute:

```bash
docker compose up -d
```

3. Acesse via navegador:

```
http://localhost:9000
```

Credenciais padrão:
- **Usuário:** `admin`
- **Senha:** `admin`

---

## ☁️ Parte 2: Provisionando na DigitalOcean com Terraform

Este projeto também permite provisionar uma Droplet na DigitalOcean com Docker, Docker Compose e o ambiente SonarQube configurado automaticamente.

### 📦 Pré-requisitos

- [Terraform instalado](https://developer.hashicorp.com/terraform/downloads)
- Chave SSH cadastrada na [DigitalOcean](https://docs.digitalocean.com/products/droplets/how-to/add-ssh-keys/)
- Token de API da DigitalOcean
- Acesso ao terminal como `sudo` ou `root`

### 🔧 Configuração de Variáveis

Crie um arquivo `terraform.tfvars` com:

```hcl
droplet_name   = "sonarqube-instance"
droplet_region = "nyc3"             # ou outro: "sfo3", "ams3"
droplet_size   = "s-2vcpu-4gb"      # recomendado para o SonarQube
```

No arquivo `datasource.tf`, defina sua chave SSH:

```hcl
data "digitalocean_ssh_key" "ssh-sonarqube" {
  name = "nome-da-sua-chave-no-DigitalOcean"
}
```

---

### 🚀 Como Usar

1. Clone o repositório:

```bash
git clone https://github.com/gabrieloliverlima/sonarqube.git
cd sonarqube
```

2. Inicialize o Terraform:

```bash
terraform init
```

3. Planeje a execução:

```bash
terraform plan
```

4. Provisione a infraestrutura:

```bash
terraform apply
```

5. Após a criação, pegue o IP da droplet:

```bash
terraform output
```

6. Acesse via navegador:

```
http://<IP_DA_DROPLET>:9000
```

Credenciais padrão:
- **Usuário:** `admin`
- **Senha:** `admin`

---

### 🔐 Segurança

As seguintes portas estão abertas por padrão:

- **22**: SSH
- **80/443**: Web
- **9000**: SonarQube
- **5432**: PostgreSQL

Você pode ajustar essas portas no recurso `digitalocean_firewall`.

---

### 📁 Estrutura do Projeto

```
├── compose.yml          # Configuração do Docker Compose local
├── datasource.tf        # Data source para chave SSH
├── main.tf              # Recursos principais (Droplet, Firewall)
├── output.tf            # Saída de IP da Droplet
├── provider.tf          # Configuração do provedor DigitalOcean
├── script.sh            # Script remoto de instalação do Docker + SonarQube
├── terraform.tfvars     # Valores definidos pelo usuário
├── variables.tf         # Declaração de variáveis
└── README.md            # Este arquivo
```

---

## 📌 Notas Finais

- Projeto voltado para fins educacionais e laboratoriais.
- Para ambientes de produção, recomenda-se usar volumes externos, backups automáticos e práticas de segurança reforçadas.


