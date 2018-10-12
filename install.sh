sudo yum update

sudo yum install -y git build-essential libreadline zlib1g libyaml libc6 libgdbm ncurses
sudo yum install -y gcc-c++ patch readline readline-devel zlib zlib-devel
sudo yum install -y libyaml-devel libffi-devel openssl-devel make
sudo yum install -y bzip2 autoconf automake libtool bison iconv-devel sqlite-devel
sudo yum install -y mysql-devel
sudo amazon-linux-extras -y install GraphicsMagick1.3

gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -L get.rvm.io | bash -s stable

source /home/ec2-user/.rvm/scripts/rvm

rvm install 2.5.1

gem install rails

git clone https://github.com/horsfieldsa/imagetrends.git

cd imagetrends

bundle install

rails db:create
rails db:migrate
rails db:seed

sudo iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 3000
export AWS_REGION=us-west-2
rails s