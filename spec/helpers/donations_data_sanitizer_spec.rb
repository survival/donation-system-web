# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/helpers/donations_data_sanitizer'

RSpec.describe Helpers::DonationsDataSanitizer do
  let(:params) do
    {
      'type' => 'recurring',
      'amount' => '12.5',
      'currency' => 'gbp',
      'giftaid' => 'yes',
      'token' => 'tok_foo',
      'name' => 'Name Lastname',
      'email' => 'user@example.com',
      'address' => 'Address',
      'city' => 'City',
      'state' => 'undefined',
      'zip' => '12345',
      'country' => 'United Kingdom',
      'method' => 'stripe'
    }
  end

  it 'strips html tags' do
    params = { 'name' => 'bar <script>harmfulstuff' }
    sanitized_data = described_class.execute(params)
    expect(sanitized_data.name).to eq('bar harmfulstuff')
  end

  describe 'when sent bad params' do
    let(:data) { described_class.execute('unsupported' => 'bar') }

    it 'does not return unsupported params' do
      expect(data.respond_to?(:unsupported)).to be(false)
    end

    it 'returns empty data if supported param is missing' do
      expect(data.amount).to eq('')
    end
  end

  describe 'when converting POST params to data structure' do
    let(:data) { described_class.execute(params) }

    it 'has a donation type' do
      expect(data.type).to eq('recurring')
    end

    it 'has an amount' do
      expect(data.amount).to eq('12.5')
    end

    it 'has a currency' do
      expect(data.currency).to eq('gbp')
    end

    it 'has a giftaid' do
      expect(data.giftaid).to eq(true)
    end

    it 'has a token' do
      expect(data.token).to eq('tok_foo')
    end

    it 'has a name' do
      expect(data.name).to eq('Name Lastname')
    end

    it 'has an email' do
      expect(data.email).to eq('user@example.com')
    end

    it 'has an address' do
      expect(data.address).to eq('Address')
    end

    it 'has a city' do
      expect(data.city).to eq('City')
    end

    it 'has a state' do
      expect(data.state).to eq('undefined')
    end

    it 'has a zip code' do
      expect(data.zip).to eq('12345')
    end

    it 'has a country' do
      expect(data.country).to eq('United Kingdom')
    end

    it 'has a method' do
      expect(data.method).to eq('stripe')
    end
  end

  describe 'when payment is done through paypal' do
    let(:paypal_params) do
      paypal_params = params.dup
      paypal_params['token'] = 'PAY-13J25512E99606838LJU7M4Y,DUFRQ8GWYMJXC'
      paypal_params['method'] = 'paypal'
      paypal_params
    end

    it 'has token containing payment and payer id' do
      data = described_class.execute(paypal_params)
      expect(data.token.payment_id).to eq('PAY-13J25512E99606838LJU7M4Y')
      expect(data.token.payer_id).to eq('DUFRQ8GWYMJXC')
    end
  end
end
