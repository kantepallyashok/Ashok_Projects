# This Repo contains sample Application, deploying in different tools.
- 1. Create Infra using AWS cloudformation and deploye app in Ec2 Instances.
  2. Create Infra using Terraform and deploye app in ec2 Instances.
  3. create infra using Terraform and Deploye app in K8.
 
# Create Infrastructure using AWS CloudFormation and deploy the app in EC2 instances:
  - You will define the infrastructure using CloudFormation templates (YAML or JSON).
  - The template would include resources like EC2 instances, security groups, key pairs, and possibly an Auto Scaling group.
  - After launching the EC2 instances, use a provisioner like UserData to deploy the application on them.

# Create Infrastructure using Terraform and deploy the app in EC2 instances:
  - With Terraform, you’ll define your infrastructure using HashiCorp Configuration Language (HCL).
  - The Terraform configuration will create EC2 instances, security groups, key pairs, and other necessary AWS resources.
  - Similar to the CloudFormation setup, after provisioning, deploy the app using a provisioner like remote-exec or UserData.
  - 
# Create Infrastructure using Terraform and deploy the app in Kubernetes (K8s):
  - You’ll use Terraform to create infrastructure (likely an EKS cluster in AWS).
  - After creating the Kubernetes cluster, you can use kubectl or a Terraform kubernetes provider to manage deployments and services.
  - The application will be containerized, and you’ll deploy it using Kubernetes objects like Deployment, Service, and Ingress.
  - Let me know if you need help with specific parts of these steps.
