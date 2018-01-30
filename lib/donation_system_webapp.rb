# frozen_string_literal: true

require 'sinatra'
require 'sinatra/json'

require_relative 'helpers/asset_paths_generator'
require_relative 'helpers/donations_data_sanitizer'
require_relative 'page/error'
require_relative 'page/home'
require_relative 'page/success'
require_relative 'routes/donations'
require_relative 'routes/paypal_create'

class DonationSystemWebapp < Sinatra::Base
  set :views, "#{settings.root}/../views"
  set :public_folder, "#{settings.root}/../public"
  set :stripe_public_key, ENV['STRIPE_PUBLIC_KEY']
  set :paypal_mode, ENV['PAYPAL_MODE']
  set :assets, 'https://assets.survivalinternational.org'
  set :asset_paths_generator, Helpers::AssetPathsGenerator.new(
    ENV['DONATIONS_ENVIRONMENT']
  )

  get '/' do
    @page = Page::Home.new
    erb :form
  end

  post '/paypal-create' do
    result = Routes::PaypalCreate.execute(params.merge(paypal_redirect_urls))
    json id: result.item.id, errors: result.errors
  end

  post '/donations' do
    errors = Routes::Donations.execute(params)
    redirect '/success' if errors.empty?
    @page = Page::Error.new(errors)
    erb :form
  end

  get '/success' do
    @page = Page::Success.new(settings.assets)
    erb :success
  end

  helpers do
    def paypal_create_url
      "#{request&.base_url}/paypal-create"
    end

    def paypal_execute_url
      "#{request&.base_url}/donations"
    end

    def paypal_token_separator
      Helpers::DonationsDataSanitizer::PAYPAL_TOKEN_SEPARATOR
    end
  end

  private

  def paypal_redirect_urls
    {
      'return_url' => paypal_create_url,
      'cancel_url' => request&.base_url
    }
  end
end
