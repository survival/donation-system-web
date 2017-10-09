# frozen_string_literal: true

require 'sinatra'

class DonationSystemWebapp < Sinatra::Base
  get '/' do
    'Hello, World!'
  end
end
