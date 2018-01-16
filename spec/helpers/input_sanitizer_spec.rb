# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/helpers/input_sanitizer'

RSpec.describe Helpers::InputSanitizer do
  it 'strips html tags' do
    params = { 'name' => 'bar <script>harmfulstuff' }
    sanitized_data = described_class.execute(params)
    expect(sanitized_data.name).to eq('bar harmfulstuff')
  end

  describe 'when converting POST params to data structure' do
    let(:params) do
      {
        'type' => 'recurring',
        'amount' => '12.5',
        'giftaid' => 'yes',
        'name' => 'Name Lastname',
        'email' => 'user@example.com',
        'token' => 'tok_foo',
        'address' => 'Address',
        'city' => 'City',
        'state' => 'undefined',
        'zip' => '12345',
        'country' => 'United Kingdom'
      }
    end
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
  end

  describe 'when sent bad params' do
    let(:data) { described_class.execute('foo' => 'bar') }

    it 'does not return unsupported params' do
      expect(data.respond_to?(:foo)).to be(false)
    end

    it 'returns empty data if param is missing' do
      expect(data.amount).to eq('')
    end
  end
end
