# Open Banking Design Patterns

This repository provides a collection of design patterns in Python, SQL, and Terraform to show how open banking API data can be saved, analyzed, and shared with external parties. See the sections below for details.

# API Log Architecture

![image](https://user-images.githubusercontent.com/38080604/233801899-497e97e9-5872-4392-be4d-c9c092ac9411.png)

## What Is Included

* Python code and dependencies for saving Finicity API log data to Delta Lake using Rust
* SQL queries for analysis 
* Terraform code for sharing data to external consumers 

### 1. Data Aggregator API to Delta Lake Python code 

AWS Lambda is used in this codebase to demonstrate how callback logs can be saved to an open format, namely Delta Lake. This relies on the callback registration with Finicity. Once this is complete, users can easily save data to Delta Lake in near real-time using AWS Lambda.

### 2. Dashboard SQL Queries 

Once data is saved to Delta Lake, you can easily create an external table using Spark SQL as shown below. This data can then be queried using the SQL engine of your choice.

``
create external table api_logs
using delta
location 's3://lakehouse-delta/api_txns15'
;
``

### 3. Automation for Delta Sharing

Using infrastructure as code is key to scaling out deployment, CI/CD, and repeatability across an enterprise. The terraform scripts in this repository will help demonstrate how data sharing can be automated and governed with Unity Catalog and Delta Sharing.