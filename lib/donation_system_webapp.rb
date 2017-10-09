# frozen_string_literal: true

require 'sinatra'

class DonationSystemWebapp < Sinatra::Base
  set :views, "#{settings.root}/../views"
  set :public_folder, "#{settings.root}/../public"

  get '/' do
    erb :home
  end
end
