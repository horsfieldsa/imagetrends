#!/bin/bash
yum update -y
yum install -y git build-essential libreadline zlib1g libyaml libc6 libgdbm ncurses
yum install -y gcc-c++ patch readline readline-devel zlib zlib-devel
yum install -y libyaml-devel libffi-devel openssl-devel make
yum install -y bzip2 autoconf automake libtool bison iconv-devel sqlite-devel
yum install -y mysql-devel ruby-devel rubygems
yum install -y gcc libxml2 libxml2-devel libxslt libxslt-devel


amazon-linux-extras install -y GraphicsMagick1.3
amazon-linux-extras install -y ruby2.4

git clone https://github.com/horsfieldsa/imagetrends.git /opt/imagetrends