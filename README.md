# imagetrends

A mock workload for a fictitious company used to learn and deliver demonstrations of AWS services. Think of this as a learning
platform that can be modified as needed to test AWS services. Some functionality is built with demonstrations in mind, so it is
by no means an example of a Production ready application. However the goal over-time, is to evolve it to be as Production ready
as possible, while demonstrating capabilities in real-world-like use-cases.

## Disclaimer

This sample appliation is configured to deploy the application on an EC2 instance as a hosted docker container in Rails Development mode. This is not the way you would want to host this application in production. The application is served by Puma and uses a SQL Lite database. It's fairly fragile,
barely supports concurrency, but because of this is great at generating errors for testing monitoring and for use in simple demonstrations.

## Deployment

The sample application is deployed via a CloudFormation template (template.yaml). When you launch this CloudFormation template it will prompt you for a few items:

1. Stack Name - Choose Something Unique
2. Instance Size - Choose an Instance Size (Be Frugal)
3. SSH Key - Chose or Create an SSH Key (Used to SSH into Instance)
4. SSHLocation - Your Current Location (Input IP Address or Range to Allow SSH From)

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


