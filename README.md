# ☁️ CloudNexus — End-to-End DevSecOps Pipeline on AWS

> *Push code. Watch it get tested, secured, containerized, and deployed — automatically.*

[![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?logo=github-actions&logoColor=white)](https://github.com/features/actions)
[![IaC](https://img.shields.io/badge/IaC-Terraform-7B42BC?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Container](https://img.shields.io/badge/Container-Docker-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![Cloud](https://img.shields.io/badge/Cloud-AWS%20EC2-FF9900?logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Security](https://img.shields.io/badge/Security-Trivy%20%2B%20SonarCloud-4E9BCD)](https://trivy.dev/)

---

## 🧭 What Is This?

CloudNexus is a **fully automated DevSecOps pipeline** that takes a Python Flask application from source code to a live, running server on AWS — with **security baked in at every step**, not bolted on at the end.

This isn't a tutorial follow-along. It's a project I built from scratch to understand how modern engineering teams actually ship software safely and repeatedly.

---

## ⚡ The Pipeline at a Glance

```
Git Push → Code Quality Scan → Security Scan → Docker Build → AWS Provision → Live Deploy
```

| Stage | Tool | What It Does |
|---|---|---|
| **Trigger** | GitHub Actions | Detects every push and kicks off the workflow |
| **Code Quality** | SonarCloud | Flags bugs, code smells, and maintainability issues |
| **Vulnerability Scan** | Trivy | Scans the image for CVEs and exposed secrets |
| **Containerization** | Docker | Packages the app into a portable, reproducible image |
| **Infrastructure** | Terraform | Provisions EC2, security groups, and networking as code |
| **Deployment** | SSH + Shell | Pulls image and runs the container on the EC2 instance |

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Developer                            │
│                      git push origin                        │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                   GitHub Actions CI/CD                      │
│                                                             │
│   ┌──────────┐   ┌──────────┐   ┌──────────┐              │
│   │SonarCloud│ → │  Trivy   │ → │  Docker  │              │
│   │  (SAST)  │   │ (Vuln)   │   │  Build   │              │
│   └──────────┘   └──────────┘   └──────────┘              │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                        AWS Cloud                            │
│                                                             │
│   ┌─────────────────────────────────────────────────────┐  │
│   │   Terraform → EC2 Instance + Security Groups        │  │
│   │                                                     │  │
│   │         Flask App running in Docker Container       │  │
│   └─────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## 🛠️ Tech Stack

- **AWS EC2** — Cloud compute for hosting the application
- **Terraform** — Infrastructure defined as code, fully reproducible
- **Docker** — Consistent, portable application packaging
- **GitHub Actions** — Automated CI/CD pipeline on every push
- **SonarCloud** — Static analysis for code quality (SAST)
- **Trivy** — Container and filesystem vulnerability scanning
- **Python Flask** — Lightweight backend application

---

## 🔐 Security Philosophy

Security is a first-class citizen in this pipeline — not an optional step at the end.

- **Shift-left scanning** — SonarCloud catches issues at the code level before they ever reach production
- **Container CVE scanning** — Trivy blocks deployment if HIGH severity vulnerabilities are found
- **Secret detection** — Pipeline flags committed secrets before they land in images
- **IAM-based access** — AWS permissions are scoped tightly using IAM roles and policies
- **GitHub Secrets** — No credentials hardcoded; all sensitive values stored encrypted
- **Restricted security groups** — EC2 only exposes the ports it actually needs

---

## 🚧 Real Challenges I Solved

This project didn't go smoothly on the first try — and that's where the real learning happened.

**SSH Timeout in CI/CD**
The pipeline couldn't reach EC2 from the GitHub Actions runner. Root cause: security group wasn't correctly allowing port 22. Fixed by auditing inbound rules and confirming the correct `ec2-user` and public IP were in use.

**Blank EC2 Had No Tools**
Deployment failed immediately — `git: command not found`, `docker: command not found`. Fresh EC2 instances come with nothing. Solved by adding automated provisioning steps in the deployment script to install all required tools on first boot.

**SonarCloud Blocked the Pipeline**
Misconfigured `sonar.projectKey` and missing organization ID caused pipeline failures. Fixed by correctly wiring the SONAR_TOKEN secret and aligning the sonar-project.properties config.

**Trivy Found Real Vulnerabilities**
Trivy halted the pipeline on HIGH severity CVEs and detected a `.pem` file in the repo. This forced me to properly understand vulnerability reports, distinguish true positives from false positives, and practice secure file handling.

**Terraform Kept Creating New EC2 Instances**
Every `terraform apply` spun up a fresh instance with a new IP, breaking the stored `EC2_HOST` secret. Learned the importance of stable infrastructure design and understood Terraform's state management behavior deeply.

---

## 📁 Project Structure

```
cloudnexus/
├── app/
│   └── app.py                  # Flask application
├── .github/
│   └── workflows/
│       └── pipeline.yml        # GitHub Actions CI/CD workflow
├── terraform/
│   ├── main.tf                 # EC2 + networking resources
│   ├── variables.tf
│   └── outputs.tf
├── Dockerfile                  # Container build definition
├── sonar-project.properties    # SonarCloud configuration
└── README.md
```

---

## 🚀 How to Run This Locally

**Prerequisites:** AWS CLI configured, Terraform installed, Docker installed

```bash
# 1. Clone the repo
git clone https://github.com/yourusername/cloudnexus.git
cd cloudnexus

# 2. Provision infrastructure
cd terraform
terraform init
terraform apply

# 3. Build and run the app locally
docker build -t cloudnexus-app .
docker run -p 5000:5000 cloudnexus-app
```

Visit `http://localhost:5000` to see the app running.

For the full automated pipeline, push to `main` — GitHub Actions handles everything from there.

---

## 📊 Key Takeaways

Building this project gave me hands-on experience with things you can't fully understand from documentation alone:

- How CI/CD pipelines break in production-like conditions — and how to debug them
- Why Infrastructure as Code matters when you need to reproduce environments reliably
- How security scanning tools integrate into a developer workflow without becoming friction
- The real behavior of Terraform state, and why stable infrastructure design is critical
- How secrets management works across GitHub, AWS, and containerized deployments

---

## 🔮 What's Next

- **Kubernetes on EKS** — Moving from single EC2 to container orchestration
- **Prometheus + Grafana** — Observability and metrics dashboards
- **Blue/Green Deployments** — Zero-downtime release strategy
- **Auto Scaling + Load Balancing** — Production-grade availability
- **Centralized Logging** — Aggregating logs across services

---

## 👨‍💻 About Me

I'm actively building hands-on skills in AWS, DevOps, CI/CD automation, and cloud security — with a focus on real projects over theoretical study.

CloudNexus is part of a broader journey toward a career as a Cloud / DevOps Engineer.

📬 [Connect with me on LinkedIn](https://linkedin.com/in/yourprofile) | 🐙 [More projects on GitHub](https://github.com/yourusername)

---

*If this project resonated with you, a ⭐ on the repo goes a long way!*
