# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/donations'

RSpec.describe Donations do
  describe 'when successful' do
    before do
      allow(DonationSystem::Payment).to receive(:attempt).and_return([])
    end

    it 'sets the configuration for the Money gem' do
      expect(I18n.enforce_available_locales).to be_falsy
    end

    it 'sanitizes parameters' do
      allow(Helpers::InputSanitizer).to receive(:execute)
      described_class.donate('foo' => 'bar')
      expect(Helpers::InputSanitizer).to have_received(:execute)
        .with('foo' => 'bar')
    end

    it 'attempts a donation' do
      data = Helpers::DonationData.new(
        '', '', '', false, '', '', '', '', '', '', '', '', ''
      )
      described_class.donate('foo' => 'bar')
      expect(DonationSystem::Payment).to have_received(:attempt).with(data)
    end

    it 'is okay if payment has no errors' do
      result = described_class.donate('foo' => 'bar')
      expect(result).to be_empty
    end
  end

  describe 'when failing' do
    it 'is not okay if payment has errors' do
      allow(DonationSystem::Payment).to receive(:attempt).and_return([:error])
      result = described_class.donate('foo' => 'bar')
      expect(result).not_to be_empty
    end
  end
end
