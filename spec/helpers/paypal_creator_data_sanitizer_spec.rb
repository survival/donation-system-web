# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/helpers/paypal_creator_data_sanitizer'

RSpec.describe Helpers::PaypalCreatorDataSanitizer do
  let(:params) do
    {
      'amount' => '12.5',
      'currency' => 'gbp',
      'return_url' => 'http://return.com',
      'cancel_url' => 'http://cancel.com'
    }
  end

  it 'strips html tags' do
    params = { 'currency' => 'bar <script>harmfulstuff' }
    sanitized_data = described_class.execute(params)
    expect(sanitized_data.currency).to eq('bar harmfulstuff')
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

    it 'has an amount' do
      expect(data.amount).to eq('12.5')
    end

    it 'has a currency' do
      expect(data.currency).to eq('gbp')
    end

    it 'has a return url' do
      expect(data.return_url).to eq('http://return.com')
    end

    it 'has a cancel url' do
      expect(data.cancel_url).to eq('http://cancel.com')
    end
  end
end
