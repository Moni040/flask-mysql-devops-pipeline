
# Terraform + Jenkins + Docker CI/CD for Flask & MySQL

A complete **end-to-end DevOps project** that provisions AWS infrastructure using **Terraform** and deploys a **Dockerized Flask + MySQL application** using **Jenkins CI/CD**.

This project demonstrates:

* Infrastructure as Code (IaC)
* Secure SSH-based deployments
* Jenkins pipelines
* Docker & Docker Compose
* Real-world DevOps workflows

---

## 📌 Architecture Overview

```
Local Machine
   |
   | (Terraform + AWS credentials)
   v
AWS Account
 ├── Jenkins EC2
 │     ├── Jenkins
 │     ├── Docker
 │     └── CI/CD Pipeline
 │
 └── App EC2
       ├── Docker
       ├── Docker Compose
       ├── Flask App
       └── MySQL Database
```

---

## 🧰 Tech Stack

| Category   | Tools                  |
| ---------- | ---------------------- |
| IaC        | Terraform              |
| Cloud      | AWS EC2                |
| CI/CD      | Jenkins                |
| Containers | Docker, Docker Compose |
| Backend    | Flask (Python)         |
| Database   | MySQL                  |
| OS         | Ubuntu 22.04           |
| SCM        | GitHub                 |

---

## 📁 Project Structure

```
.
├── terraform/
│   ├── provider.tf
│   ├── variables.tf
│   ├── keypair.tf
│   ├── security_groups.tf
│   ├── jenkins_ec2.tf
│   ├── app_ec2.tf
│   ├── outputs.tf
│   └── user-data/
│       ├── jenkins.sh
│       └── app.sh
│
├── app/
│   ├── app.py

│
├── tests/
│   └── test_app.py
│
├── docker-compose.yml
│── requirements.txt
|── Dockerfile
├── deploy.sh
├── Jenkinsfile
└── README.md
```

---

## 🔐 Prerequisites (VERY IMPORTANT)

### On Your Local Machine

* Terraform `>= 1.x`
* AWS CLI
* Git
* SSH client
* Git Bash or WSL (recommended on Windows)

Verify:

```bash
terraform -version
aws --version
ssh -V
```

---

## 🔑 AWS Credentials Setup (LOCAL MACHINE ONLY)

Terraform authenticates to AWS using **your local AWS credentials**.

```bash
aws configure
```

Enter:

* AWS Access Key
* AWS Secret Key
* Region: `us-east-1`
* Output: `json`

Credentials are stored at:

```
~/.aws/credentials
~/.aws/config
```

❌ **DO NOT** commit AWS credentials to GitHub
❌ **DO NOT** put AWS keys in Jenkins

---

## 🔐 SSH Key (PEM & PUB) Setup

1. Create an (PEM & PUB) key pair in your local:

  Use the command "ssh-keygen -t rsa -b 2048 -f flask-ec2-key"

2. Save both the keys securely in your local :


## 🚀 Phase 1: Provision Infrastructure (Terraform)

### 1️⃣ Navigate to Terraform directory

```bash
cd terraform
```


### 3️⃣ Initialize Terraform

```bash
terraform init
```

---

### 4️⃣ Apply Terraform

```bash
terraform apply
```

Type:

```
yes
```

---

### 5️⃣ Capture Outputs

Terraform will output:

```
jenkins_ip = x.x.x.x
app_ip     = y.y.y.y
```

📌 **Save these IPs**

---

## 🚀 Phase 2: Jenkins Setup

### 1️⃣ SSH into Jenkins EC2

```bash
ssh -i terraform-jenkins-key.pem ubuntu@<JENKINS_IP>
```

### 2️⃣ Open Jenkins UI

```
http://<JENKINS_IP>:8080
```

Unlock Jenkins:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

---

### 3️⃣ Install Required Jenkins Plugins

Go to:

```
Manage Jenkins → Plugins
```

Install:

* Git
* GitHub Integration
* Pipeline
* SSH Agent
* Docker Pipeline

Restart Jenkins if prompted.

---

## 🔐 Jenkins Credentials (MANDATORY)

Go to:

```
Manage Jenkins → Credentials → Global → Add Credentials
```

### Required Credentials

| ID                 | Type                          | Purpose             |
| ------------------ | ----------------------------- | ------------------- |
| `EC2_SSH_KEY`      | SSH Username with private key | SSH to App EC2      |
| `DB_PASSWORD`      | Secret Text                   | MySQL app password  |
| `DB_ROOT_PASSWORD` | Secret Text                   | MySQL root password |

For `EC2_SSH_KEY`:

* Username: `ubuntu`
* Private Key: paste `.pem` content

---

## 🚀 Phase 3: Jenkins Pipeline

### 1️⃣ Create Pipeline Job

* New Item → Pipeline
* Name: `flask-mysql-ci-cd`
* Pipeline script from SCM
* Git Repo URL: your repo
* Branch: `*/main`

---

### 2️⃣ Jenkinsfile Environment Variables

```groovy
environment {
  EC2_HOST = "ubuntu@<APP_EC2_PUBLIC_IP>"
  APP_DIR  = "flask-mysql-ci-cd"
  DB_NAME  = "appdb"
  DB_USER  = "appuser"
}
```

---

### 3️⃣ Run Pipeline

Click:

```
Build Now
```

Pipeline steps:

1. Checkout code
2. Run pytest
3. Build Docker image
4. SSH into App EC2
5. Run `deploy.sh`

---

## 🚀 Phase 4: Application Deployment

### 1️⃣ SSH into App EC2

```bash
ssh -i terraform-jenkins-key.pem ubuntu@<APP_EC2_IP>
```

### 2️⃣ Check containers

```bash
docker ps
```

---

### 3️⃣ Check logs

```bash
docker compose logs -f
```

---

### 4️⃣ Verify application

Browser:

```
http://<APP_EC2_IP>:5000/health
```

Expected:

```json
{"status":"ok"}
```

---

## 🧪 Testing

### Health Endpoint Test

```bash
curl http://localhost:5000/health
```

### Pytest

```bash
pytest tests/
```

---

## 🔁 Redeployment Flow

```bash
git commit -m "change"
git push
```

Jenkins automatically redeploys.

---

## 🛑 Cleanup (Destroy Everything)

```bash
terraform destroy -var="my_ip=49.37.182.91/32"
```

---

## ❗ Common Issues & Fixes

### SSH Timeout

✔ Check Security Groups
✔ Ensure correct public IP
✔ Check NACL allows port 22 & ephemeral ports

### Docker Permission Error

```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

---

## 🧠 Project Summary

> “This project provisions Jenkins and application infrastructure using Terraform and implements a Jenkins CI/CD pipeline to deploy a Dockerized Flask-MySQL application via SSH.”

---

## 📌 Future Improvements

* Elastic IP
* ALB + HTTPS
* AWS SSM (no SSH)
* Remote Terraform state
* Monitoring (CloudWatch)
* Zero-downtime deployment

---

## ⭐ Author

**Monish H V**
DevOps | Cloud | CI/CD | Terraform | AWS

---
