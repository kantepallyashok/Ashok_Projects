# OpenSupports Application Build & Deployment Documentation

## Overview
**OpenSupports** : 
    OpenSupports is a simple, open-source ticket system for managing customer support queries. It features easy ticket management, user roles, and email notifications. It's ideal for small to medium-sized businesses needing a straightforward support solution.

This documentation outlines the deployment of the OpenSupports application using AWS CloudFormation and a CI/CD pipeline. The project provisions necessary AWS infrastructure and automates deployment across multiple environments (development, staging, production).

## Agenda
This assignment involves the development of **CloudFormation templates** to provision infrastructure for the **OpenSupports** application, an open-source ticketing system. The primary objectives are:

- Set up a **CI/CD pipeline** to automate the deployment of the application across multiple environments (development, staging, and production).
- Ensure smooth promotion between environments while maintaining best practices for **security** and **cost optimization**.
- Incorporate **CloudWatch Alarms** for real-time monitoring of application performance and resource usage.
- Add **SNS email notifications** to alert stakeholders if any deployment stage fails or critical alarms are triggered, ensuring prompt responses to issues.


## Here are the condensed points focusing on your deliverables:

## Main Contents
- **[CloudFormation Templates]**
  CloudFormation template (`opensupports/cf_templates/templates/Infrastructure.yaml`) mainly has 3 blocks to deploy the infrastructure:
    - Resources  - Parameters  - Outputs  
  
    - **AWS CF templates** are reusable templates; by passing parameters, we can create multiple environments. - The folder structure defines CF templates, and by passing different parameters (from `opensupports/cf_templates/parameters/*.yaml` files), we can create multiple environments.

- **[CI/CD Pipeline Configuration]**
   - The CI/CD pipeline automates the build, testing, and deployment processes for the OpenSupports application.
   - In ci-cd pipeline, we are using child templates to avoid code reuse.
   - We are implementing a **SNS** topic also, for sending emails on fails.

   # Note:  
    ## Pipeline has different conditions

    - Trigger 
        ( if Develeopment parameters change only dev stage trigger)
        ( if Staging parameters change only Staging stage trigger)
        ( if Prodution parameters change only Prod stage trigger)

    - Staging stage is depending on Dev stage. after Dev stage success Staging stage will trigger, 
      if stage fails "Notification" will send.

    - After staging stage gets success, it will wait for approval from 2 users, for 60 minutes,
      if 2 users  didnt respond, it will send notification to entire team mail, and someone has to approve manulaly. if deployement fails, it sends notification.

    - Initially only 2 users ( Manager, TL) will have access to approve.No other team member will get access for first 60 minutes.
    -  After 60 minutes, on demand case we can enable team members permissions, and get approval.

## CloudFormation Templates (Infrastructure.yaml)
The CloudFormation templates are designed to create the following AWS resources:

### 1. **Resources** --- 

**VPC, EC2, S3, RDS, IAM Roles, CloudWatch Alarms**  
Detailed AWS resources are created using the CloudFormation template:

- **VPC**: A Virtual Private Cloud to host the application securely.
- **Public and Private Subnets**: Subnets for hosting resources; public for external access, private for internal resources.
- **Internet Gateway**: Allows communication between instances in the VPC and the internet.
- **Security Group**: Controls inbound traffic to the application.
- **EC2 Instance**: The server instance for running the OpenSupports application.
- **RDS Instance**: Managed database for the application.
- **S3 Bucket**: Storage for static files.
- **CloudWatch Alarm**: Monitors CPU utilization and triggers alerts.
- **SNS Topic**: Sends notifications based on alarms.

### 2. **Parameters** --- 
These are the inputs for the parameters; this template can be reused for different environments just by passing parameters.

- **VpcCidr**: CIDR block for the VPC.
- **VpcName**: Name of the VPC.
- **PublicSubnetCidr**: CIDR block for the public subnet.
- **PrivateSubnetCidr**: CIDR block for the private subnet.
- **KeyName**: Key pair for SSH access.
- **Environment**: Deployment environment (dev, stage, prod).
- **InstanceType**: EC2 instance type.
- **AmiId**: AMI ID for the EC2 instance.
- **OSSecurityGroupId**: Security Group ID for the application.
- **DBInstanceClass**: RDS DB instance class.
- **DBName**: RDS database name.
- **DBUsername**: RDS master username.
- **DBPassword**: RDS master password (not visible in logs).
- **BucketName**: S3 bucket name for static file storage.
- **CloudWatchAlarmName**: CloudWatch alarm name for CPU monitoring.
- **AlarmThreshold**: CPU Utilization alarm threshold.
- **SnsTopicArn**: SNS Topic ARN for alarm notifications.

### 3. **Outputs**
Outputs defined in the template provide information about the created resources:
- **VPCId**: ID of the created VPC.
- **PublicSubnetId**: ID of the public subnet.
- **PrivateSubnetId**: ID of the private subnet.
- **SecurityGroupId**: ID of the security group.
- **EC2InstanceId**: ID of the EC2 instance.
- **EC2InstancePublicIP**: Public IP of the EC2 instance.
- **DBInstanceId**: ID of the RDS instance.
- **S3BucketName**: Name of the S3 bucket.

## CI/CD Pipeline Configuration (azure_pipeline.yaml)
The CI/CD pipeline automates the build and deployment process for the OpenSupports application. It includes the following stages:

1. **Build Stage**  
   - Installs dependencies for both frontend and backend.  
     - Frontend: `npm install` for all required packages.  
     - Backend: Uses `make build` to compile the backend code.  
   - The pipeline compiles the code and prepares it for deployment.

2. **Test Stage**  
   - Runs unit tests for both frontend and backend.  
     - Backend: Executes `make test` to validate API functionality.  
     - Frontend: Runs `npm test` for UI validation.

3. **Create Artifact**  
   - Generates a deployment artifact in the form of a ZIP file that contains both frontend and backend application code. This artifact is used in later stages for deployment.

4. **Publish Artifacts**  
   - Publishes the generated artifacts to the pipeline workspace for further stages to upload to S3.

5. **Upload to S3**  
   - The deployment artifact is uploaded to an S3 bucket, the name of which is fetched dynamically from AWS CloudFormation outputs.

6. **Development, Staging, and Production Stages**  
   - These stages deploy the application to respective environments.  
     - **Development**: Uses `dev-parameters.yaml` for the deployment.  
     - **Staging**: Uses `staging-parameters.yaml` for staging environment deployment.  
     - **Production**: Uses `prod-parameters.yaml` for the production environment.

## Advantages of Child Templates(CI_CD\deploy-template.yaml)
By using child templates, the pipeline allows reusability and modularity in application deployments. This enables dynamic and environment-specific infrastructure provisioning without duplicating the entire template for each environment.

## SNS Topic and Email Notifications
The **SNS Topic** is used to send notifications for critical alarms (like CloudWatch alarms) or deployment status. These notifications can be sent via email to inform stakeholders of any issues or successful deployments.


Steps to deploye application:

1. Create Azure devops account, AWS account 
2. Open Azure devops and create Pipeline, along with Create service connection to integrate with AWS.
3. Note down all AWS keys, and variables need to give as pipeline secret variables, while creating pipeline give this secrets.
4. Run the pipeline, check the stages are successfully completed or not and check email is sending notification or not.
5. check application running or not by using "http://your-ec2-public-ip:your-port-number"
Ex: 
   - ssh -i path/to/your/key.pem ubuntu@your-ec2-public-ip
   - curl http://localhost:your-port-number
   - systemctl status your-service-name

# **Cost Optimization Suggestions for AWS CloudFormation Template**
To make the AWS CloudFormation template more cost-effective while maintaining security and management features, here are some suggestions:

## **Instance Sizing and Auto-Scaling:**

- Replace fixed EC2 instance types (`InstanceType: !Ref InstanceType`) with a parameterized or spot instance option, or use **Auto Scaling Groups (ASGs)** to manage scaling based on demand.
- You can add the option for **EC2 Spot Instances** if workloads allow. Spot instances are significantly cheaper than on-demand instances.

## **RDS Optimizations:**

- Consider using **Amazon RDS Aurora** instead of standard RDS for potentially better cost-performance optimization, especially for MySQL workloads.
- Enable **RDS Multi-AZ** deployment only if required for production. In development or staging environments, a single instance is more cost-effective.
- Scale down **AllocatedStorage** for RDS to the minimum required size or utilize **RDS storage autoscaling**.

## **S3 Bucket and CloudFront:**

- Use **S3 Intelligent-Tiering** for cost-optimized storage based on access patterns if your bucket stores files that are accessed less frequently.
- If your application needs to serve static files globally, consider adding **CloudFront** in front of the S3 bucket to minimize bandwidth costs.

## **Use Reserved Instances (RI) or Savings Plans:**

- For long-running workloads, use **Reserved Instances** or **Savings Plans** to save up to 72% on EC2 and RDS compared to on-demand instances.

## **CloudWatch and Monitoring:**

- Review the frequency of **CloudWatch metrics** (e.g., period = 300 seconds). Lowering the monitoring frequency can reduce costs.
- Consider consolidating **CloudWatch alarms** and using **Composite Alarms** to minimize the number of active alarms.

## **Security Groups:**

- Review your **Security Groups** for unnecessary open ports (e.g., open SSH to 0.0.0.0/0). Instead, restrict access to specific IPs or use **AWS Systems Manager Session Manager** for secure SSH access without needing port 22 open.
