# AWS ECS Deployment for Ashok Practice

## Overview
This documentation outlines the deployment of the application using **Docker** for containerization and **AWS ECS (Elastic Container Service)** for orchestration. The project provisions the necessary infrastructure and automates deployment across multiple environments (development, staging, production).

## Agenda
This assignment involves the development of **Docker configurations** to provision infrastructure for the AWS ECS application. The primary objectives are:

- Set up a **CI/CD pipeline** to automate the deployment of the application across multiple environments (development, staging, production).
- Ensure smooth promotion between environments while maintaining best practices for **security** and **cost optimization**.
- Incorporate **CloudWatch Alarms** for real-time monitoring of application performance and resource usage.
- Add **SNS email notifications** to alert stakeholders if any deployment stage fails or critical alarms are triggered, ensuring prompt responses to issues.

## Main Contents

### [Docker Configurations]
The Docker configurations (`Dockerfile` for frontend and backend) primarily consist of the following:

- **frontend/Dockerfile**: Provisions the frontend application.
- **backend/Dockerfile**: Provisions the backend application.
- **docker-compose.yml**: Defines and runs multi-container Docker applications for both frontend and backend services (if applicable).

### [CI/CD Pipeline Configuration]
The Azure DevOps pipeline automates the build, testing, and deployment processes for the AWS ECS application. The pipeline includes several stages:

1. **Build Stage**
   - Builds Docker images for both frontend and backend services.
  
2. **Test Stage**
   - Runs unit tests for both frontend and backend services to ensure functionality.
  
3. **Create Artifact**
   - Generates deployment artifacts (Docker images) that are used in later stages for deployment.
  
4. **Publish Artifacts**
   - Publishes the generated artifacts to the pipeline workspace for later use.
  
5. **Deploy to AWS ECS**
   - Deploys the application to respective environments using AWS ECS configurations:
     - **Development**
     - **Staging**
     - **Production**

### Note on Pipeline Conditions
- **Triggers**:
  - Development parameters change only trigger the development stage.
  - Staging parameters change only trigger the staging stage.
  - Production parameters change only trigger the production stage.

- **Stage Dependencies**:
  - The staging stage depends on the successful completion of the development stage. If the development stage fails, a notification is sent.

- **Manual Approval for Production**:
  - After the staging stage completes successfully, the pipeline waits for approval from designated users for a specified duration.
  - If no response is received, a notification is sent to the team to approve manually.

### AWS ECS Deployment Configuration
The AWS ECS deployment configurations are designed to create the following resources:

1. **Task Definitions**: 
   - Defines the frontend and backend applications with specified resource limits, environment variables, and logging configuration.
   
2. **Services**: 
   - Creates services for frontend and backend to manage scaling and load balancing.
   
3. **Load Balancers**: 
   - Configures an Application Load Balancer (ALB) to distribute incoming traffic across multiple tasks.
   
4. **Security Groups**: 
   - Sets up security groups to control inbound and outbound traffic to the ECS tasks.

### Advantages of Using Docker and AWS ECS
Using Docker and AWS ECS promotes scalability, flexibility, and efficient resource utilization. It enables seamless deployment, easy rollbacks, and enhanced application availability.

### SNS Topic and Email Notifications
The **SNS Topic** is utilized to send notifications for critical alarms (such as CloudWatch alarms) or deployment statuses. Notifications can be sent via email to inform stakeholders of any issues or successful deployments.

## How to Deploy

1. **Install Docker and AWS CLI**: Ensure both Docker and the AWS CLI are properly installed and configured.

2. **Build Docker Images**:
   - From the root of the project directory, run:
     ```bash
     docker build -t <your-frontend-image-name> -f frontend/Dockerfile .
     docker build -t <your-backend-image-name> -f backend/Dockerfile .
     ```

3. **Run Tests**:
   - For the frontend:
     ```bash
     docker run --rm <your-frontend-image-name> npm test
     ```
   - For the backend:
     ```bash
     docker run --rm <your-backend-image-name> npm test
     ```

4. **Push Docker Images to AWS ECR**:
   - Authenticate Docker to your Amazon ECR registry:
     ```bash
     aws ecr get-login-password --region <your-region> | docker login --username AWS --password-stdin <your-account-id>.dkr.ecr.<your-region>.amazonaws.com
     ```
   - Tag and push the images:
     ```bash
     docker tag <your-frontend-image-name>:latest <your-account-id>.dkr.ecr.<your-region>.amazonaws.com/<your-frontend-repo>:latest
     docker push <your-account-id>.dkr.ecr.<your-region>.amazonaws.com/<your-frontend-repo>:latest
     ```

5. **Deploy to AWS ECS**:
   - Use the Terraform configurations to provision AWS ECS infrastructure:
     ```bash
     terraform init
     terraform apply
     ```

6. **Monitor the Deployment**:
   - Use the AWS Management Console to check the status of your ECS tasks and services.

## Conclusion
This project demonstrates a full CI/CD pipeline with Docker and AWS ECS integration. Ensure to adjust configurations and paths according to your specific project requirements.
