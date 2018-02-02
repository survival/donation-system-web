# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/routes/donations'

RSpec.describe Routes::Donations do
  describe 'when donation is successful' do
    before do
      allow(DonationSystem::Payment).to receive(:attempt).and_return([])
    end

    it 'sets the configuration for the Money gem' do
      described_class.execute('param' => 'irrelevant')
      expect(I18n.enforce_available_locales).to be_falsy
    end

    it 'sanitizes parameters' do
      allow(Helpers::DonationsDataSanitizer).to receive(:execute)
      described_class.donate('param' => 'irrelevant')
      expect(Helpers::DonationsDataSanitizer).to have_received(:execute)
        .with('param' => 'irrelevant')
    end

    it 'attempts a donation' do
      data = Helpers::DonationData.new(
        '', '', '', false, '', '', '', '', '', '', '', '', ''
      )
      described_class.donate('param' => 'irrelevant')
      expect(DonationSystem::Payment).to have_received(:attempt).with(data)
    end

    it 'is okay if payment has no errors' do
      result = described_class.donate('param' => 'irrelevant')
      expect(result).to be_empty
    end
  end

  describe 'when donation is unsuccessful' do
    it 'has errors' do
      allow(DonationSystem::Payment).to receive(:attempt).and_return([:error])
      result = described_class.donate('param' => 'irrelevant')
      expect(result).not_to be_empty
    end
  end
end
