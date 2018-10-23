# imagetrends

A mock workload for a fictitious company used to learn and deliver demonstrations of AWS services. Think of this as a learning
platform that can be modified as needed to test AWS services. Some functionality is built with demonstrations in mind, so it is
by no means an example of a Production ready application. However the goal over-time, is to evolve it to be as Production ready
as possible, while demonstrating capabilities in real-world-like use-cases.

## Disclaimer

This sample application is intentionally hosted on a single EC2 instance for demonstration purposes only. The application could be modified to be deployed on ECS, EKS, or your platform of choice using the docker-compose.yaml file as an example of the information you'd need to pass to the appliation container to connect to an external database. You can also run it as a single-instance docker container using a SQL lite database by omitting the RAILS_ENV environment variable (which will force rails to default to development mode).

The template.yaml CloudFormation template depends on a public AMI with some dependencies installed. This is to speed up deployment during workhops and demos.

If you want to create your own AMI you can use/modify /scripts/crate_base_instance_for_ami.yaml as needed. This template installs all dependencies, and builds the docker container via user-data (again, for demonstration purposes only).

## Overview 

![Alt text](documentation/imagetrends.png?raw=true "ImageTrends Screenshot")

The application is a simple Ruby on Rails (5.2) application with a MySql (8) database. The application runs as two docker containers, one for the application (ui) and one for the database (db). You can control the deployment of these containers by modifying docker-compose.yaml.

The application simulates an image asset management application. Authenticated users can uploaded images (stored as blobs in the database). Once images are uploaded, background jobs (using suckerpunch) are started to analyze and collect metadata about the images. Four of these jobs use AWS Rekognition to detect labels, moderation labels, text, and celebrities. One of thes jobs reads EXIF (if avaiable) metadata to determine the camera model used to take the image.

## Deployment

The sample application is deployed via a CloudFormation template (template.yaml). When you launch this CloudFormation template it will prompt you for a few items:

1. Stack Name - Choose Something Unique
2. Instance Size - Choose an Instance Size (Be Frugal)
3. SSH Key - Chose or Create an SSH Key (Used to SSH into Instance)
4. SSHLocation - Your Current Location (Input IP Address or Range to Allow SSH From)
5. HTTPLocation - Your Current Location (Input IP Address or Range to Allow HTTP From)

The CloudFormation template will deploy the following resources into your account.

1. An EC2 Instance
2. An IAM Role and Instance Profile (Associated with EC2 Instance) to allow Rekognition API calls.
3. A Security Group (Allowing SSH and HTTP)

The CloudFormation template will output several items which will be useful for accessing the sample application.

1. Instance Id
2. Sample Application Public IP
3. Availability Zone
4. Sample Application Public DNS

You can launch the sample application stack through this button:

WARNING: Make sure you deploy it to a supported region (See Below)

[![Launch Stack](https://cdn.rawgit.com/buildkite/cloudformation-launch-stack-button-svg/master/launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=ImageTrendsSampleApp&templateURL=https://s3-us-west-2.amazonaws.com/imagetrends-sample-application/template.yaml)

## Log Files

The application and database containers write log files to mounted volumes in the following locations:

* Application: /opt/imagetrends-logs/ui
  * application.log
  * production.log
  * xray.log
* Database: /opt/imagetrends-logs/db
  * NOT YET IMPLEMENTED

## AWS X-Ray Support

The application uses AWS X-Ray (via: https://github.com/aws/aws-xray-sdk-ruby) to record and monitor all HTTP, SDK and Database calls. After the application has received some traffic you should see a service map as shown below in the region where the application is hosted. 

![Alt text](documentation/xray.png?raw=true "AWS X-Ray Screenshot")

## Limitations

### Supported Regions

* us-west-2 (Oregon)

### Planned Regions

* us-east-1 (Northern Virginia)
* us-east-2 (Ohio)
* eu-west-1 (Ireland)
* ap-northeast-1 (Tokyo)
* ap-southeast-2 (Sydney)

## Sample Photos

You can download some sample photos to use with the application here: 	https://s3-us-west-2.amazonaws.com/imagetrends-sample-application/sample-photos.zip

These images are covered by the Death to Stock Photo licensing terms outlined here: https://deathtothestockphoto.com/official-license/