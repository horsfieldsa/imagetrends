#--- Base AMI User Data (Use this to build a Ruby base AMI if you don't want to use the public AMI references in distributed-nested/autoscaling-group.yaml)

#!/bin/bash -xe
# Update instance
yum update -y
# Install Compilers
yum install -y curl gpg gcc gcc-c++ make libcurl-devel openssl-devel zlib-devel ruby-devel
yum install -y git libyaml ncurses readline readline-devel zlib \
               zlib-devel libyaml-devel libffi-devel openssl-devel \
               bzip2 autoconf automake libtool bison iconv-devel redhat-rpm-config mysql-devel sqlite-devel

# Install x-ray Daemon
curl https://s3.dualstack.us-east-2.amazonaws.com/aws-xray-assets.us-east-2/xray-daemon/aws-xray-daemon-3.x.rpm -o /home/ec2-user/xray.rpm
yum install -y /home/ec2-user/xray.rpm
# Install stress-ng
curl http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/l/libbsd-0.8.3-1.el7.x86_64.rpm -o /home/ec2-user/libbsd.rpm
yum install -y /home/ec2-user/libbsd.rpm
curl http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/s/stress-ng-0.07.29-2.el7.x86_64.rpm -o /home/ec2-user/stress-ng.rpm
yum install -y /home/ec2-user/stress-ng.rpm
# Install NodeJS
amazon-linux-extras install -y epel
yum install -y --enablerepo=epel nodejs npm
# Install Ruby 
amazon-linux-extras install -y ruby2.4
# Install Bundler
gem install bundler --no-rdoc --no-ri