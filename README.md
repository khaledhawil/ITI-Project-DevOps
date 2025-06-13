# ITI DevOps Project - Enterprise E-commerce Platform

## Project Overview

This project represents a comprehensive implementation of modern DevOps practices for a full-stack e-commerce application. The solution demonstrates end-to-end automation from development to production deployment using industry-standard tools and methodologies.

**Application**: Amazona E-commerce Platform  
**Version**: 1.0.2  
**Architecture**: Microservices with 3-tier deployment  
**Demo**: https://amazonaapp.herokuapp.com/

## Table of Contents

- [Infrastructure Architecture](#infrastructure-architecture)
- [CI/CD Pipeline Overview](#cicd-pipeline-overview)
- [Continuous Integration](#continuous-integration)
- [Continuous Deployment](#continuous-deployment)
- [Kubernetes Architecture](#kubernetes-architecture)
- [Application Components](#application-components)
- [Technology Stack](#technology-stack)
- [Infrastructure as Code](#infrastructure-as-code)
- [Configuration Management](#configuration-management)
- [Deployment Guide](#deployment-guide)
- [Monitoring and Logging](#monitoring-and-logging)
- [Security Implementation](#security-implementation)

## Infrastructure Architecture

![Infrastructure Architecture](./svg/infra_aws.drawio.svg)

The infrastructure is built on Amazon Web Services (AWS) following best practices for scalability, security, and high availability. The architecture implements Infrastructure as Code (IaC) principles using Terraform for consistent and reproducible deployments.

### Core Infrastructure Components

**Network Layer**
- Custom VPC with public and private subnets across multiple Availability Zones
- Internet Gateway and NAT Gateways for secure internet access
- Route tables and security groups for network isolation
- Network ACLs for additional security layer

**Compute Layer**
- Amazon EKS (Elastic Kubernetes Service) for container orchestration
- EC2 instances for Jenkins CI/CD server
- Auto Scaling Groups for dynamic resource management
- Load Balancers for traffic distribution

**Storage and Database**
- Amazon EBS volumes for persistent storage
- Amazon S3 for artifact storage and static content
- MongoDB deployment within Kubernetes cluster

**Security and Monitoring**
- AWS IAM roles and policies for secure access control
- Amazon CloudWatch for monitoring and alerting
- AWS Backup for automated backup strategies
- Security groups and NACLs for network security

### Terraform Infrastructure Modules

The infrastructure is organized into modular Terraform components:

- **Network_Module**: VPC, subnets, routing, and security configurations
- **EKS_Cluster_Module**: Kubernetes cluster setup with worker nodes
- **Jenkins_EC2_Module**: CI/CD server provisioning and configuration
- **ECR_Module**: Container registry for Docker image management
- **S3_Logs_Module**: Centralized logging and artifact storage
- **Aws_Backup_Module**: Automated backup policies and schedules

## CI/CD Pipeline Overview

![Complete CI/CD Pipeline](./svg/cicd.drawio.svg)

The CI/CD pipeline implements GitOps methodology with automated testing, security scanning, and deployment processes. The pipeline ensures code quality, security compliance, and reliable deployments across environments.

### Pipeline Characteristics

- **Automated Triggering**: Git webhook integration for automatic pipeline execution
- **Parallel Processing**: Concurrent build and test execution for faster feedback
- **Quality Gates**: Automated testing and code quality checks
- **Security Integration**: Vulnerability scanning with Trivy
- **Artifact Management**: Docker image versioning and registry management
- **Deployment Automation**: Zero-downtime deployments to Kubernetes

## Continuous Integration

![Continuous Integration Process](./svg/ci.drawio.svg)

The CI process focuses on code integration, automated testing, and artifact creation with comprehensive quality assurance measures.

### CI Pipeline Stages

**Source Code Management**
- Git repository integration with webhook triggers
- Branch-based workflow with merge request validation
- Automated change detection and impact analysis

**Build Process**
- Node.js application compilation for both frontend and backend
- Dependency installation and package optimization
- Environment-specific configuration management

**Testing Framework**
- Unit testing with Jest for both React and Node.js components
- Integration testing for API endpoints and database connections
- End-to-end testing for critical user workflows
- Code coverage analysis and reporting

**Security Scanning**
- Static Application Security Testing (SAST) with integrated tools
- Dependency vulnerability scanning
- Container image security analysis with Trivy
- License compliance verification

**Artifact Creation**
- Docker image building with multi-stage optimization
- Image tagging strategy for version management
- Push to Amazon ECR with automated cleanup policies

### Quality Assurance

- **Code Quality**: ESLint and Prettier for JavaScript code standards
- **Test Coverage**: Minimum 80% coverage requirement
- **Security Gates**: Zero tolerance for high-severity vulnerabilities
- **Performance Testing**: Load testing for critical API endpoints

## Continuous Deployment

![Continuous Deployment Process](./svg/cd.drawio.svg)

The CD process handles automated deployment to multiple environments with comprehensive validation and rollback capabilities.

### Deployment Strategy

**Environment Promotion**
- Development environment for initial testing
- Staging environment for integration testing
- Production environment with blue-green deployment strategy

**GitOps Implementation**
- ArgoCD for declarative Kubernetes deployments
- Git repository as single source of truth for configurations
- Automated synchronization between Git state and cluster state

**Deployment Validation**
- Health checks and readiness probes
- Smoke testing post-deployment
- Performance validation and monitoring
- Automated rollback on failure detection

**Release Management**
- Semantic versioning for release tracking
- Release notes automation
- Change log generation
- Deployment notifications via Discord integration

## Kubernetes Architecture

![Kubernetes Deployment Architecture](./svg/k8s.drawio.svg)

The Kubernetes architecture implements a scalable, resilient microservices deployment with comprehensive monitoring and security measures.

### Cluster Architecture

**Control Plane**
- Amazon EKS managed control plane for high availability
- etcd cluster for configuration storage
- API server with RBAC authentication
- Scheduler and controller manager for workload orchestration

**Worker Nodes**
- Multi-AZ node groups for high availability
- Auto Scaling Groups for dynamic scaling
- Spot instances for cost optimization
- Dedicated node pools for different workload types

**Networking**
- Amazon VPC CNI for native AWS networking
- Network policies for micro-segmentation
- Ingress controllers for external traffic management
- Service mesh capabilities for advanced traffic control

### Application Deployment

**Frontend Tier**
- React.js application deployed as multiple replicas
- Horizontal Pod Autoscaler for dynamic scaling
- LoadBalancer service for external access
- CDN integration for static asset delivery

**Backend Tier**
- Node.js API servers with health check endpoints
- Service discovery for inter-service communication
- Configuration management via ConfigMaps and Secrets
- Database connection pooling and optimization

**Database Tier**
- MongoDB StatefulSet with persistent storage
- Automated backup and restore procedures
- Read replicas for improved performance
- Data encryption at rest and in transit

### Kubernetes Resources

- **Deployments**: Application workload management
- **Services**: Network access and load balancing
- **ConfigMaps**: Configuration data management
- **Secrets**: Sensitive data encryption and access
- **PersistentVolumes**: Storage management
- **Ingress**: External traffic routing
- **HorizontalPodAutoscaler**: Automatic scaling
- **NetworkPolicies**: Security and isolation

## Application Components

### Frontend Application

**Technology Stack**
- React.js 16.12 with modern hooks and functional components
- Redux for centralized state management
- React Router for client-side routing
- Axios for API communication
- Responsive design with CSS Grid and Flexbox

**Key Features**
- Product catalog with search and filtering
- Shopping cart with persistent storage
- User authentication and authorization
- Order management and history
- Payment integration with PayPal
- Admin dashboard for content management

**Performance Optimizations**
- Code splitting and lazy loading
- Image optimization and compression
- Caching strategies for API responses
- Bundle size optimization

### Backend Application

**Technology Stack**
- Node.js with Express.js framework
- MongoDB with Mongoose ODM
- JWT for stateless authentication
- AWS SDK for cloud service integration
- Multer for file upload handling

**API Architecture**
- RESTful API design principles
- Comprehensive error handling and validation
- Rate limiting and security middleware
- API documentation with OpenAPI/Swagger
- Logging and monitoring integration

**Database Design**
- Document-based data modeling
- Indexing strategies for performance
- Data validation and schema enforcement
- Backup and recovery procedures

### Security Implementation

**Authentication and Authorization**
- JWT-based stateless authentication
- Role-based access control (RBAC)
- Password hashing with bcrypt
- Session management and token expiration

**Data Protection**
- Input validation and sanitization
- SQL injection prevention
- XSS protection mechanisms
- CORS configuration for API security

**Infrastructure Security**
- Network segmentation with security groups
- Encryption in transit and at rest
- Secrets management with Kubernetes Secrets
- Container security scanning

## Technology Stack

### Frontend Technologies
- **Framework**: React.js 16.12
- **State Management**: Redux with React-Redux
- **Routing**: React Router DOM 5.1
- **HTTP Client**: Axios 1.9
- **Build Tool**: Create React App
- **Testing**: Jest and React Testing Library

### Backend Technologies
- **Runtime**: Node.js with Express.js 4.17
- **Database**: MongoDB with Mongoose 8.15
- **Authentication**: JSON Web Tokens 9.0
- **File Upload**: Multer with S3 integration
- **Security**: Helmet, CORS, Rate Limiting

### DevOps and Infrastructure
- **Containerization**: Docker with multi-stage builds
- **Orchestration**: Kubernetes on Amazon EKS
- **CI/CD**: Jenkins with pipeline as code
- **Infrastructure**: Terraform for IaC
- **Configuration**: Ansible for server management
- **Monitoring**: AWS CloudWatch and Prometheus
- **Security**: Trivy for vulnerability scanning
- **GitOps**: ArgoCD for deployment automation

### Cloud Services (AWS)
- **Compute**: EKS, EC2, Auto Scaling Groups
- **Storage**: EBS, S3, EFS
- **Database**: DocumentDB (MongoDB compatible)
- **Networking**: VPC, ALB, CloudFront
- **Security**: IAM, KMS, Secrets Manager
- **Monitoring**: CloudWatch, X-Ray
- **Backup**: AWS Backup service

## Infrastructure as Code

### Terraform Configuration

The infrastructure is defined using Terraform with a modular approach for reusability and maintainability.

**Main Configuration**
```hcl
# Provider and backend configuration
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Module instantiation
module "network" {
  source = "./Modules/Network_Module"
  # Module configuration
}

module "eks_cluster" {
  source = "./Modules/EKS_Cluster_Module"
  # Module configuration
}
```

**Variable Management**
- Environment-specific variable files
- Sensitive data handling with Terraform Cloud
- Variable validation and type constraints
- Default value strategies

## Configuration Management

### Ansible Automation

Ansible playbooks handle server configuration and application deployment automation.

**Role Structure**
- **Docker_installation**: Container runtime setup
- **Jenkins_Server_Installation**: CI/CD server configuration
- **Cloud_Watch_Agent_Installation**: Monitoring agent setup
- **trivy_installation**: Security scanner installation

**Playbook Execution**
```yaml
---
- hosts: jenkins_servers
  become: yes
  roles:
    - Docker_installation
    - Jenkins_Server_Installation
    - Cloud_Watch_Agent_Installation
    - trivy_installation
```

## Deployment Guide

### Prerequisites

**Local Development Environment**
- Node.js 16+ and npm
- Docker and Docker Compose
- kubectl and helm
- Terraform CLI
- AWS CLI configured

**AWS Account Setup**
- IAM user with appropriate permissions
- EKS cluster access
- ECR repository access
- S3 bucket for Terraform state

### Local Development

```bash
# Clone repository
git clone <repository-url>
cd ITI-Project

# Start local development environment
docker-compose up -d

# Access applications
# Frontend: http://localhost:3000
# Backend: http://localhost:5000
# MongoDB: mongodb://localhost:27017
```

### Infrastructure Deployment

```bash
# Initialize Terraform
cd Terraform
terraform init

# Plan infrastructure changes
terraform plan -var-file="terraform.tfvars"

# Apply infrastructure
terraform apply -var-file="terraform.tfvars"

# Configure servers with Ansible
cd ../Ansible
ansible-playbook -i my_inventory.ini roles_playbook.yml
```

### Application Deployment

**Kubernetes Deployment**
```bash
# Deploy to Kubernetes
cd k8s
kubectl apply -f .

# Verify deployment
kubectl get pods -n ecommerce
kubectl get services -n ecommerce
```

**ArgoCD GitOps Deployment**
```bash
# Apply ArgoCD application
kubectl apply -f argo/application.yaml

# Monitor deployment
kubectl get applications -n argocd
```

## Monitoring and Logging

### CloudWatch Integration

- **Application Metrics**: Custom metrics for business KPIs
- **Infrastructure Metrics**: EC2, EKS, and RDS monitoring
- **Log Aggregation**: Centralized logging from all services
- **Alerting**: Proactive notifications for critical issues

### Monitoring Stack

**Prometheus and Grafana**
- Kubernetes cluster monitoring
- Application performance metrics
- Custom dashboards for operational insights
- Alert manager for notification routing

**Logging Strategy**
- Structured logging with JSON format
- Log rotation and retention policies
- Centralized log analysis with ELK stack
- Real-time log streaming capabilities

## Security Implementation

### Container Security

- **Base Image Scanning**: Vulnerability assessment of container images
- **Runtime Security**: Monitoring for suspicious container behavior
- **Network Policies**: Micro-segmentation within Kubernetes
- **RBAC**: Role-based access control for Kubernetes resources

### Data Security

- **Encryption**: TLS 1.3 for data in transit
- **At-Rest Encryption**: AWS KMS for data storage encryption
- **Secrets Management**: Kubernetes Secrets and AWS Secrets Manager
- **Backup Encryption**: Encrypted backups with key rotation

### Compliance and Governance

- **Security Scanning**: Automated vulnerability assessments
- **Compliance Monitoring**: CIS benchmarks and security standards
- **Audit Logging**: Comprehensive audit trails
- **Access Control**: Principle of least privilege implementation

## Contributing

### Development Workflow

1. Fork the repository and create a feature branch
2. Implement changes with appropriate testing
3. Run local validation and security scans
4. Submit pull request with detailed description
5. Automated CI/CD pipeline validates changes
6. Code review and approval process
7. Automated deployment to staging environment
8. Production deployment after validation

### Code Standards

- **JavaScript**: ESLint with Airbnb configuration
- **Docker**: Multi-stage builds and security best practices
- **Kubernetes**: Resource limits and security contexts
- **Terraform**: Module structure and variable validation

## Contributors

This project was developed by the ITI DevOps team:

- **Khalid Hawil** (@khaledhawil) - DevOps Engineer
- **Abdelrahman Elshahat** (@AbdelrahmanElshahat) - DevOps Engineer  
- **Alaa Elnagy** (@alaa-elnagy) - DevOps Engineer
- **Sara Ghoim** (@saraghonim) - DevOps Engineer
- **Menna Hamouda** (@MennaHamouda) - DevOps Engineer

---

**Project Status**: Production Ready  
**Last Updated**: June 2025  
**Maintainer**: ITI DevOps Team