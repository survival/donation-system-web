# frozen_string_literal: true

require 'spec_helper.rb'
require_relative '../../lib/page/error'

module Page
  RSpec.describe Error do
    let(:page) { described_class.new([:missing_data]) }

    it 'has a title' do
      expect(page.title).not_to be_nil
    end

    it 'has an explanation' do
      expect(page.ui(:explanation)).not_to be_nil
    end

    it 'has a message to invite supporter to try again' do
      expect(page.ui(:retry_message)).not_to be_nil
    end

    it 'formats errors' do
      ui_error_description = described_class::STRIPE_ERRORS[:missing_data]
      expect(page.error_list).to include(ui_error_description)
    end

    it 'returns the error code if there is no description for it' do
      page = described_class.new([:i_have_no_description_yet])
      expect(page.error_list).to include('i_have_no_description_yet')
    end
  end
end
