# AWS Serverless ETL Pipeline

End-to-end serverless ETL pipeline on AWS using S3, Glue, Step Functions, Lambda, and Redshift (provisioned with Terraform).

## 📌 Project Overview

This project demonstrates the design and implementation of a scalable, cloud-native data pipeline built entirely with AWS serverless services.

The pipeline ingests raw transactional data (NYC Taxi dataset), performs transformations using AWS Glue, orchestrates workflow dependencies with AWS Step Functions, and loads optimized analytical tables into Amazon Redshift for reporting and analytics. It focuses on:
- Dimensional modeling (star schema)
- ETL/ELT transformation design
- Orchestration planning (Step Functions style workflow)
- Infrastructure-as-Code structure (Terraform-ready)
- Production-minded documentation and maintainable repo structure

Infrastructure is provisioned using Terraform to ensure reproducibility, scalability, and Infrastructure-as-Code best practices.

## 🛠 Development Environment

This project is designed to be deployable to AWS.  
For local development and testing, the data warehouse layer is simulated using Docker + PostgreSQL to avoid cloud costs.

All infrastructure is structured for AWS (S3, Glue, Step Functions, Redshift) and provisioned via Terraform.

## 📂 Dataset

This project uses the NYC Taxi Yellow Trip dataset (May 2025).

Due to file size constraints, raw data is not stored in the repository.

You can download the dataset from:
https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page

Place the downloaded file inside:
data/raw/


## 🏗 Architecture

**High-Level Flow:**

1. Raw dataset is stored in Amazon S3
2. AWS Glue performs data cleansing and transformation (PySpark and/or SparkSQL)
3. AWS Step Functions orchestrates pipeline execution
4. Transformed data is loaded into Amazon Redshift (Postgres locally for development)
5. Monitoring and alerts are handled via CloudWatch and SNS

(Architecture diagram to be added here)


## 🧱 Tech Stack

**Target AWS Stack**
- Storage: S3
- ETL: Glue (PySpark)
- Orchestration: Step Functions
- Warehouse: Redshift
- IaC: Terraform
- Monitoring: CloudWatch / SNS

**Local Dev (optional, cost-free)**
- Postgres (warehouse simulation)
- Docker (repeatable local environment)

**Language**
- Python / SQL


## 📊 Data Modeling (Star Schema)

This project implements a star schema optimized for analytics:

### Dimensions
- `dim_vendor` (VendorID mappings) :contentReference[oaicite:8]{index=8}  
- `dim_payment_type` (payment_type mappings) :contentReference[oaicite:9]{index=9}  
- `dim_rate_code` (RatecodeID mappings) :contentReference[oaicite:10]{index=10}  
- `dim_location` (TLC Taxi Zones lookup; referenced by PULocationID/DOLocationID) :contentReference[oaicite:11]{index=11}  
- `dim_date` (derived from pickup/dropoff timestamps)

### Fact
- `fact_trips` contains trip-level measures and foreign keys to the dimensions

Schema files live in `sql/schema/`. Dimension seed scripts live in `sql/seeds/`.


## 🌱 Dimension Seeding

The following seed scripts populate code mappings for consistent analytics:
- `sql/seeds/seed_dim_vendor.sql`
- `sql/seeds/seed_dim_payment_type.sql`
- `sql/seeds/seed_dim_rate_code.sql`

These are based on the official TLC data dictionary. 

## ⚙️ Infrastructure Provisioning

All AWS resources are provisioned using Terraform modules:

- S3 buckets
- IAM roles and policies
- Glue jobs
- Step Functions state machine
- Redshift cluster

## 🚀 Next Steps / Enhancements

- Add Taxi Zone lookup ingestion to populate `dim_location`
- Implement transformation scripts (PySpark) to produce staging + warehouse-ready outputs
- Add orchestration definition (Step Functions JSON)
- Add local runner (Docker + Postgres) and reproducible load scripts
- Add CI checks (SQL linting, basic validation)

## 📬 Contact

Connect with me on LinkedIn for questions, feedback, or data engineering opportunities.
