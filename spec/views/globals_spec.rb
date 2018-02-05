# frozen_string_literal: true

require 'spec_helper'
require_relative 'app_helper'

RSpec.describe 'Sinatra globals' do
  describe('#settings') do
    it 'sets the Stripe public key' do
      expect(app.settings.stripe_public_key).not_to be_nil
    end

    it 'sets the PayPal mode' do
      expect(app.settings.paypal_mode).not_to be_nil
    end

    it 'sets the assets url' do
      expect(app.settings.assets).not_to be_nil
    end

    it 'sets the asset paths generator' do
      expect(app.settings.asset_paths_generator).not_to be_nil
    end
  end

  describe('#helpers') do
    let(:request) { RequestFake.new('http://example.com') }

    it 'sets the asset paypal create url' do
      expect(app.helpers.paypal_create_url).not_to be_nil
    end

    it 'sets the asset paypal execute url' do
      expect(app.helpers.paypal_execute_url).not_to be_nil
    end

    it 'sets the asset paypal token separator' do
      expect(app.helpers.paypal_token_separator).not_to be_nil
    end

    RequestFake = Struct.new(:base_url)
  end
end
