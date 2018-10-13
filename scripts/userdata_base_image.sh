#!/bin/bash
yum update -y
yum install -y git
amazon-linux-extras install -y docker
service docker start

git clone https://github.com/horsfieldsa/imagetrends.git /opt/imagetrends

cd /opt/imagetrends
docker build -t imagetrends:latest .
iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 3000

REGION=`curl http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}'`
echo $REGION

docker run -d --rm --label=imagetrends -it -v /opt/imagetrends-logs:/app/log -e "AWS_REGION=${REGION}" --network=host imagetrends:latest