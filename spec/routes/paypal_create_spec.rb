# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/routes/paypal_create'

RSpec.describe Routes::PaypalCreate do
  describe 'when Paypal payment creation is successful' do
    let(:result) { DonationSystem::Result.new('payment', []) }

    before do
      allow(DonationSystem::PaypalWrapper::PaymentCreator)
        .to receive(:execute).and_return(result)
    end

    it 'sanitizes parameters' do
      allow(Helpers::PaypalCreatorDataSanitizer).to receive(:execute)
      described_class.execute('param' => 'irrelevant')
      expect(Helpers::PaypalCreatorDataSanitizer).to have_received(:execute)
        .with('param' => 'irrelevant')
    end

    it 'creates a payment' do
      data = Helpers::PaypalCreatorData.new('', '', '', '')
      described_class.execute('param' => 'irrelevant')
      expect(DonationSystem::PaypalWrapper::PaymentCreator)
        .to have_received(:execute).with(data)
    end

    it 'is okay if payment has no errors' do
      result = described_class.execute('param' => 'irrelevant')
      expect(result).to be_okay
    end
  end

  describe 'when Paypal payment creation is unsuccessful' do
    it 'has errors' do
      bad_result = DonationSystem::Result.new('payment', [:error])
      allow(DonationSystem::PaypalWrapper::PaymentCreator)
        .to receive(:execute).and_return(bad_result)
      result = described_class.execute('param' => 'irrelevant')
      expect(result).not_to be_okay
    end
  end
end
