# frozen_string_literal: true

require 'spec_helper'
require_relative 'app_helper'

RSpec.describe 'Paypal create route' do
  let(:paypal_create) { JSON.parse(last_response.body) }

  describe 'when successful' do
    before do
      result = PaypalResult.new(PaypalPaymentFake.new('paymentID'), [], true)
      allow(Routes::PaypalCreate).to receive(:execute).and_return(result)
      post '/paypal-create', 'amount' => '12.34', 'currency' => 'gbp'
    end

    it 'returns the payment id as json' do
      expect(paypal_create['id']).to eq('paymentID')
    end

    it 'returns no errors' do
      expect(paypal_create['errors']).to be_empty
    end

    it 'passes the params' do
      expect(Routes::PaypalCreate).to have_received(:execute).with(
        'amount' => '12.34', 'currency' => 'gbp',
        'return_url' => anything, 'cancel_url' => anything
      )
    end
  end

  describe 'when unsuccessful' do
    before do
      result = PaypalResult.new(PaypalPaymentFake.new(nil), [:error], false)
      allow(Routes::PaypalCreate).to receive(:execute).and_return(result)
      post '/paypal-create', 'amount' => '12.34', 'currency' => 'gbp'
    end

    it 'has a null payment id' do
      expect(paypal_create['id']).to be_nil
    end

    it 'sends the errors' do
      expect(paypal_create['errors']).not_to be_empty
    end
  end

  PaypalPaymentFake = Struct.new(:id)
  PaypalResult = Struct.new(:item, :errors, :okay?)
end
