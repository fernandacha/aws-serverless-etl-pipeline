# AWS Serverless ETL Pipeline

End-to-end serverless ETL pipeline on AWS using S3, Glue, Step Functions, Lambda, and Redshift (provisioned with Terraform).

## 📌 Project Overview

This project demonstrates the design and implementation of a scalable, cloud-native data pipeline built entirely with AWS serverless services.

The pipeline ingests raw transactional data (NYC Taxi dataset), performs transformations using AWS Glue, orchestrates workflow dependencies with AWS Step Functions, and loads optimized analytical tables into Amazon Redshift for reporting and analytics.

Infrastructure is provisioned using Terraform to ensure reproducibility, scalability, and Infrastructure-as-Code best practices.

---

## 🛠 Development Environment

This project is designed to be deployable to AWS.  
For local development and testing, the data warehouse layer is simulated using Docker + PostgreSQL to avoid cloud costs.

All infrastructure is structured for AWS (S3, Glue, Step Functions, Redshift) and provisioned via Terraform.

---

## 🏗 Architecture

**High-Level Flow:**

1. Raw dataset is stored in Amazon S3
2. AWS Glue performs data cleansing and transformation
3. AWS Step Functions orchestrates pipeline execution
4. Transformed data is loaded into Amazon Redshift
5. Monitoring and alerts are handled via CloudWatch and SNS

(Architecture diagram to be added here)

---

## 🧱 Tech Stack

- **Storage:** Amazon S3
- **ETL:** AWS Glue (PySpark)
- **Orchestration:** AWS Step Functions
- **Data Warehouse:** Amazon Redshift
- **Infrastructure as Code:** Terraform
- **Monitoring:** CloudWatch & SNS
- **Language:** Python / SQL

---

## 📊 Data Modeling

The dataset is transformed into a dimensional model suitable for analytical workloads:

- Fact table: `fact_trips`
- Dimension tables:
  - `dim_date`
  - `dim_location`
  - `dim_vendor`

Optimizations include:
- Partitioning strategy for S3
- Sort and distribution keys in Redshift
- Incremental load design
- Query performance tuning

---

## ⚙️ Infrastructure Provisioning

All AWS resources are provisioned using Terraform modules:

- S3 buckets
- IAM roles and policies
- Glue jobs
- Step Functions state machine
- Redshift cluster

To deploy:

```bash
cd terraform
terraform init
terraform plan
terraform apply
