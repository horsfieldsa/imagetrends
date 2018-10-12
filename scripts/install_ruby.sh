gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -L get.rvm.io | bash -s stable

source /home/ec2-user/.rvm/scripts/rvm

rvm install -y 2.5.1

gem install -y rails