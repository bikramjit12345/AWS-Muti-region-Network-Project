 Project Overview
This project demonstrates how to build a multi-region, fault-tolerant AWS infrastructure using Terraform. The infrastructure spans two AWS regions and establishes secure and efficient communication between them using Transit Gateway Peering, Network Firewall, Application Load Balancers (ALBs), and EC2 instances in private subnets.

Key Components
Multi-Region VPC Architecture
Each region hosts its own isolated VPC, subnets, NAT gateways, route tables, and associated resources.

Transit Gateway (TGW) Peering
TGWs are deployed in each region and peered to enable secure communication between the VPCs.

Network Firewall Integration
AWS Network Firewall is deployed to inspect and filter traffic between subnets and across regions.

Application Load Balancers (ALBs)
ALBs manage north-south traffic and distribute load across EC2 instances in private subnets.

EC2 Instances
Deployed in private subnets and securely connected via TGW, these simulate app servers across regions.

Terraform Modular Design
The entire infrastructure is modularized for reusability and scalability using clean, production-ready Terraform code.

