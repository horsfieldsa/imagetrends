sudo yum update

sudo yum install git build-essential libreadline zlib1g libyaml libc6 libgdbm ncurses
sudo yum install gcc-c++ patch readline readline-devel zlib zlib-devel
sudo yum install libyaml-devel libffi-devel openssl-devel make
sudo yum install bzip2 autoconf automake libtool bison iconv-devel sqlite-devel

gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -L get.rvm.io | bash -s stable

source /home/ec2-user/.rvm/scripts/rvm