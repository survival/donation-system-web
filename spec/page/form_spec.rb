# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/page/form'

module Page
  RSpec.describe Form do
    let(:form_presenter) { described_class.new }

    it 'has a donation_type' do
      expect(form_presenter.ui(:donation_type)).not_to be_nil
    end

    it 'has a currency' do
      expect(form_presenter.ui(:currency)).not_to be_nil
    end

    it 'has a amount' do
      expect(form_presenter.ui(:amount)).not_to be_nil
    end

    it 'has a giftaid_title' do
      expect(form_presenter.ui(:giftaid_title)).not_to be_nil
    end

    it 'has a giftaid_description' do
      expect(form_presenter.ui(:giftaid_description)).not_to be_nil
    end

    it 'has a giftaid_yes_title' do
      expect(form_presenter.ui(:giftaid_yes_title)).not_to be_nil
    end

    it 'has a giftaid_yes_description' do
      expect(form_presenter.ui(:giftaid_yes_description)).not_to be_nil
    end

    it 'has a giftaid_no_title' do
      expect(form_presenter.ui(:giftaid_no_title)).not_to be_nil
    end

    it 'has a giftaid_no_description' do
      expect(form_presenter.ui(:giftaid_no_description)).not_to be_nil
    end

    it 'has a payment_method' do
      expect(form_presenter.ui(:payment_method)).not_to be_nil
    end

    it 'has a submit_button' do
      expect(form_presenter.ui(:submit_button)).not_to be_nil
    end

    it 'has a stripe_description' do
      expect(form_presenter.ui(:stripe_description)).not_to be_nil
    end

    it 'returns nothing if no ui description available' do
      expect(form_presenter.ui(:i_dont_exist_in_the_ui)).to be_nil
    end
  end
end
