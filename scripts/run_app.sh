cd /opt/imagetrends

bundle install

rails db:create
rails db:migrate
rails db:seed

sudo iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 3000
export AWS_REGION=us-west-2
puma -C config/puma.rb