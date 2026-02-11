# AWS EKS Infrastructure with Terraform

## Overview
This repository contains **Terraform code to provision a production-ready AWS infrastructure** centered around **Amazon EKS**. The setup follows AWS best practices, including:

- Multi-AZ architecture for high availability
- Public and private subnet separation
- Secure access via Bastion Host
- Auto Scaling worker nodes
- Centralized container image management using Amazon ECR
- DNS routing with Amazon Route 53

The infrastructure is modular, reusable, and designed for scalability.

---

## 🏗️ High-Level Architecture

![AWS Architecture](images/AWS%20Infrastructure%20.jpeg) consists of:
- **VPC (10.0.0.0/16)** spanning two Availability Zones
- **Public Subnets**
  - Internet-facing resources (ELB, Bastion Host, NAT Gateway)
- **Private Subnets**
  - EKS worker nodes
- **Internet Gateway (IGW)** for public access
- **NAT Gateway** for outbound internet access from private subnets
- **Application Load Balancer (ELB)**
- **Amazon EKS Cluster** with Auto Scaling Group–backed worker nodes
- **Amazon ECR** for container images
- **AWS IAM** for permissions and access control
- **Amazon Route 53** for DNS routing

---

## Repository Structure

```text
.
├── terraform-backend/
│   ├── main.tf          # Remote backend configuration (S3 + DynamoDB)
│   ├── variables.tf     # Backend input variables
│   └── outputs.tf       # Backend outputs
│
├── terraform-infra/
│   ├── modules/         # Reusable Terraform modules
│   │   ├── vpc/
│   │   ├── eks/
│   │   ├── security/
│   │   ├── iam/
│   │   └── networking/
│   ├── main.tf          # Root infrastructure definitions
│   ├── variables.tf     # Infrastructure variables
│   ├── outputs.tf       # Infrastructure outputs
│   ├── AWS Infrastructure.jpeg
│   └── README.md
```

---

## Terraform Backend

The `terraform-backend` directory configures **remote state management** using:

- **Amazon S3** for state storage
- **DynamoDB** for state locking

This ensures:

- Team-safe Terraform usage
- State consistency
- Prevention of concurrent state corruption

---

## EKS Cluster Details

- Managed **Amazon EKS control plane**
- Worker nodes deployed in **private subnets**
- Node groups managed via **Auto Scaling Groups**
- Secure communication using IAM roles and security groups

---

## Security Considerations

- No direct SSH access to private nodes
- Bastion Host in public subnet for administrative access
- IAM roles with least-privilege permissions
- Security Groups scoped per resource

---

## Prerequisites

Before deploying, ensure you have:

- Terraform >= 1.3
- AWS CLI configured with appropriate permissions
- An AWS account

---

## Deployment Steps

### 1. Initialize Backend

```bash
cd terraform-backend
terraform init
terraform apply
```

### 2. Deploy Infrastructure

```bash
cd ../terraform-infra
terraform init
terraform plan
terraform apply
```

---

## Outputs

After deployment, Terraform will output:

- EKS Cluster name
- Cluster endpoint
- VPC ID
- Subnet IDs
- Load Balancer DNS name
