#!/bin/bash
service docker start
REGION=`curl http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}'`
echo $REGION
iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 3000
docker run -d --rm --label=imagetrends -it -v /opt/imagetrends-logs:/app/log -e "AWS_REGION=${REGION}" --network=host imagetrends:latest