# imagetrends

A mock workload for a fictitious company used to learn and deliver demonstrations of AWS services. Think of this as a learning
platform that can be modified as needed to test AWS services. Some functionality is built with demonstrations and workshops in mind, so it is
by no means an example of a Production ready application. 

## Overview

![Alt text](documentation/imagetrends.png?raw=true "ImageTrends Screenshot")

The application is a simple Ruby on Rails (5.2) application with an Aurora MySql database. The application runs on EC2 and uses Puma to serve the applicaiton. This shouldn't be considered a good pattern for hosting a Rails appliation in production, but keeps things simple for demo purposes.

The application simulates an image asset management application. Authenticated users can uploaded images (stored in S3). Once images are uploaded, background jobs (using suckerpunch) are started to analyze and collect metadata about the images. Four of these jobs use AWS Rekognition to detect labels, moderation labels, text, and celebrities. One of thes jobs reads EXIF (if avaiable) metadata to determine the camera model used to take the image. Comments added to images and analyzed with AWS Comprehend to detect sentiment.

## EC2 Hosted Deployment

The EC2 hosted sample application is deployed via a CloudFormation template (cloudformation/distributed.yaml).

You can launch the sample application stack through this button:

WARNING: Make sure you deploy it to a supported region (See Below)

[![Launch Stack](https://cdn.rawgit.com/buildkite/cloudformation-launch-stack-button-svg/master/launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=ImageTrendsSampleApp&templateURL=https://s3-us-west-2.amazonaws.com/imagetrends-sample-application/distributed.yaml)

### Supported Regions

* us-west-2 (Oregon)
* eu-west-1 (Ireland)
* us-east-1 (Northern Virginia)
* us-east-2 (Ohio)
* ap-northeast-1 (Tokyo)
* ap-southeast-2 (Sydney)

## Log Files

* Application: /opt/imagetrends/logs
  * application.log
  * production.log
  * xray.log

## AWS X-Ray Support

The application uses AWS X-Ray (via: https://github.com/aws/aws-xray-sdk-ruby) to record and monitor all HTTP, SDK and Database calls. After the application has received some traffic you should see a service map as shown below in the region where the application is hosted. 

![Alt text](documentation/xray.png?raw=true "AWS X-Ray Screenshot")

## Generating Errors

For a demo application like Imagetrends, it's useful to leave some "bugs" in the system for testing various failure scenarios and responses. This is especially useful for monitoring demonstrations and recovery examples. Below are some actions that will cause application failures, as well as how to recover from these failures.

### ERROR: Image Larger than 5 MB

#### Generate

Upload an image larger than 5MB, some example images that generate these errors are included in the sample images archive referenced in the Sample Images section below.

#### Error

Logged In: application.log

```
E, [2018-10-24T12:42:28.861486 #3374] ERROR -- : Error detecting text for Image: 8 Details: 1 validation error detected: Value 'java.nio.HeapByteBuffer[pos=0 lim=7843602 cap=7843602]' at 'image.bytes' failed to satisfy constraint: Member must have length less than or equal to 5242880
```

#### Recovery

The application will recover from this error automatically, you will see tags named "Error" associated with the image for each analysis source that encountered an error.

### ERROR: Image Invalid File Type or Corrupt File

#### Generate

Upload the break_app.jpg image located in the Sample Images archive referenced in the Sample Images section below.

Logged In application.log

#### Error

```
E, [2018-10-24T12:14:23.618509 #3374]  ERROR -- : Unknown Error - Action: show Controller: images Event: ActiveStorage::InvariableError
```
```
E, [2018-10-24T12:14:26.941977 #3374] ERROR -- : Error detecting moderation labels for Image: 6 Details: Protocol wrong type for socket
```
```
E, [2018-10-24T12:14:34.302484 #3374] ERROR -- : Error detecting text for Image: 6 Details: Broken pipe
```

#### Recovery
1. Logon as an administrator (l: admin@admin.com p: Password123). You may need to access the Logon path directly at /users/sign_in
2. Open the Administration application. You may need to access the Administration application directly at /admin.
3. Delete the last image you uploaded. (Look for several Error tags)


## Sample Images

You can download some sample photos to use with the application here: 	https://s3-us-west-2.amazonaws.com/imagetrends-sample-application/sample-photos.zip

These images are covered by the Death to Stock Photo licensing terms outlined here: https://deathtothestockphoto.com/official-license/