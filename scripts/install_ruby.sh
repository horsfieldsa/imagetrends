command curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
curl -L get.rvm.io | bash -s stable

source /home/ec2-user/.rvm/scripts/rvm
rvm reload

yes | rvm install 2.5.1

gem install -y rails