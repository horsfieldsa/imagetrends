#!/bin/bash
yum update -y
yum install -y git
amazon-linux-extras install -y docker
service docker start
git clone https://github.com/horsfieldsa/imagetrends.git /opt/imagetrends
cd /opt/imagetrends
docker build -t imagetrends:latest .