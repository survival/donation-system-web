# frozen_string_literal: true

require 'spec_helper'
require_relative 'app_helper'

RSpec.describe 'Sinatra globals' do
  it 'sets the Stripe public key' do
    expect(app.settings.stripe_public_key).not_to be_nil
  end

  it 'sets the assets url' do
    expect(app.settings.assets).not_to be_nil
  end

  it 'sets the asset paths generator' do
    expect(app.settings.asset_paths_generator).not_to be_nil
  end
end
