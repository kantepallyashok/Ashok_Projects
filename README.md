# OpenSupports Application Build & Deployment Documentation

## Overview
This documentation outlines the deployment of the OpenSupports application using **Terraform** for infrastructure provisioning and **Azure DevOps (ADO)** for CI/CD automation. The project provisions necessary AWS infrastructure and automates deployment across multiple environments (development, staging, production).

## Agenda
This assignment involves the development of **Terraform configurations** to provision infrastructure for the **OpenSupports** application, an open-source ticketing system. The primary objectives are:

- Set up a **CI/CD pipeline** to automate the deployment of the application across multiple environments (development, staging, and production).
- Ensure smooth promotion between environments while maintaining best practices for **security** and **cost optimization**.
- Incorporate **CloudWatch Alarms** for real-time monitoring of application performance and resource usage.
- Add **SNS email notifications** to alert stakeholders if any deployment stage fails or critical alarms are triggered, ensuring prompt responses to issues.

## Main Contents

### [Terraform Configurations]
The Terraform configurations (`opensupports/terraform/*.tf`) primarily consist of the following files:

- **vpc.tf**: Provisions a Virtual Private Cloud (VPC) to host the application securely.
- **ec2.tf**: Configures EC2 instances for running the OpenSupports application.
- **rds.tf**: Sets up an RDS instance as a managed database for the application.
- **s3.tf**: Creates an S3 bucket for storing static files.
- **cloudwatch.tf**: Configures CloudWatch alarms for monitoring CPU utilization.
- **variables.tf**: Defines variables used throughout the Terraform configurations.
- **dev.tfvars**, **staging.tfvars**, **prod.tfvars**: Environment-specific variables files that customize the configuration for each deployment.

### [CI/CD Pipeline Configuration]
The CI/CD pipeline automates the build, testing, and deployment processes for the OpenSupports application. The pipeline includes several stages:

1. **Build Stage**
   - Installs dependencies for both frontend and backend:
     - **Frontend**: Uses `npm install` for required packages.
     - **Backend**: Uses `make build` to compile the backend code.

2. **Test Stage**
   - Runs unit tests for both frontend and backend:
     - **Backend**: Executes `make test` to validate API functionality.
     - **Frontend**: Runs `npm test` for UI validation.

3. **Create Artifact**
   - Generates a deployment artifact (ZIP file) that contains both frontend and backend application code. This artifact is used in later stages for deployment.

4. **Publish Artifacts**
   - Publishes the generated artifacts to the pipeline workspace for later use.

5. **Upload to S3**
   - The deployment artifact is uploaded to an S3 bucket, with the name dynamically fetched from Terraform outputs.

6. **Development, Staging, and Production Stages**
   - These stages deploy the application to respective environments using environment-specific variables:
     - **Development**: Uses `dev.tfvars` for deployment.
     - **Staging**: Uses `staging.tfvars` for deployment.
     - **Production**: Uses `prod.tfvars` for deployment.

### Note on Pipeline Conditions
- **Triggers**:
  - Development parameters change only triggers the development stage.
  - Staging parameters change only triggers the staging stage.
  - Production parameters change only triggers the production stage.

- **Stage Dependencies**:
  - The staging stage depends on the successful completion of the development stage. If the development stage fails, a notification is sent.

- **Manual Approval for Production**:
  - After the staging stage completes successfully, the pipeline waits for approval from two designated users (Manager and Team Lead) for 60 minutes.
  - If no response is received, a notification is sent to the entire team to approve manually.
  - Initially, only the two designated approvers will have access; after 60 minutes, permissions can be granted to the entire team for approval.

### Terraform Infrastructure Configuration (vpc.tf, ec2.tf, etc.)
The Terraform configurations are designed to create the following AWS resources:

1. **Resources**: 
   - **VPC**: Creates a Virtual Private Cloud to host the application securely.
   - **Subnets**: Configures public and private subnets for external and internal resources, respectively.
   - **Internet Gateway**: Enables communication between instances in the VPC and the internet.
   - **Security Group**: Controls inbound traffic to the application.
   - **EC2 Instance**: Hosts the OpenSupports application.
   - **RDS Instance**: Provides a managed database for the application.
   - **S3 Bucket**: Stores static files.
   - **CloudWatch Alarm**: Monitors resource utilization and triggers alerts.
   - **SNS Topic**: Sends notifications based on alarms.

2. **Variables**: 
   - Defines input parameters for reusability across environments, allowing the creation of different setups by changing only variable values.

3. **Outputs**: 
   - Provides information about the created resources, such as VPC ID, Subnet IDs, EC2 Instance ID, and S3 Bucket name.

### Advantages of Modular Terraform Configurations
By using modular Terraform configurations, the pipeline promotes reusability and maintainability, allowing dynamic and environment-specific infrastructure provisioning without duplicating entire configurations for each environment.

### SNS Topic and Email Notifications
The **SNS Topic** is utilized to send notifications for critical alarms (such as CloudWatch alarms) or deployment statuses. Notifications can be sent via email to inform stakeholders of any issues or successful deployments.


How to Deploye:

- Download terraform and Give env path
- From the folder where tf files exists run below command
   - terraform plan -var-file="parameters/terraform.dev.tfvars"
- This generates the plan and shows the resources that will generate.# Ashok_practises
