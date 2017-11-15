# frozen_string_literal: true

require 'sinatra'
require_relative 'donations'
require_relative 'page/success'

class DonationSystemWebapp < Sinatra::Base
  set :views, "#{settings.root}/../views"
  set :public_folder, "#{settings.root}/../public"
  set :stripe_public_key, ENV['STRIPE_PUBLIC_KEY']
  set :assets, 'https://s3.amazonaws.com/assets-production.survivalinternational.org'

  get '/' do
    erb :home
  end

  post '/donations' do
    errors = Donations.donate(params)
    pass if errors.empty?
    @errors = errors
    erb :error
  end

  post '/donations' do
    @page = Page::Success.new(settings.assets)
    erb :success
  end
end
