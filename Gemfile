source 'https://rubygems.org'

gem 'rails', '~> 5.2.0'

group :development, :test do
  gem 'sqlite3'
end

group :production do
  gem 'mysql2'
  gem 'redis', '~> 4.1.0'
end

gem 'bootsnap', '>= 1.1.0', require: false
gem 'chartkick'
gem 'bootstrap', '~> 4.1.0'
gem 'jquery-rails'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'mini_racer'
gem 'will_paginate'
gem 'aws-sdk-s3'
gem 'aws-sdk-rekognition'
gem 'aws-sdk-comprehend'
gem 'mini_magick'
gem 'rails_admin', '~> 1.3'
gem 'devise'
gem 'sucker_punch', '~> 2.0'
gem 'cancancan', '~> 2.0'
gem 'exifr'
gem 'oj', platform: :mri
gem 'aws-xray-sdk', require: ['aws-xray-sdk/facets/rails/railtie']

group :development, :test do
  gem 'byebug', platform: :mri
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end
