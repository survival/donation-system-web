# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.5.0'

gem 'donation_system', git: 'https://github.com/survival/donation-system',
                       branch: 'master'
gem 'nokogiri'
gem 'sinatra'
gem 'sinatra-contrib'

group :deployment, :test do
  gem 'aws-sdk-s3'
  gem 'platform-api'
end

group :test do
  gem 'coveralls', require: false
  gem 'pry'
  gem 'rack-test'
  gem 'rake'
  gem 'rspec'
  gem 'rubocop', require: false
end
