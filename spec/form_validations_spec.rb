# frozen_string_literal: true

require 'spec_helper.rb'

RSpec.describe 'Home page' do
  before(:all) { get '/' }

  def page
    @page ||= Nokogiri::HTML(last_response.body)
  end

  describe 'required fields' do
    it 'requires an amount' do
      expect(page.css('#amount').attribute('required')).not_to be_nil
    end

    it 'requires a name' do
      expect(page.css('#name').attribute('required')).not_to be_nil
    end

    it 'requires an email' do
      expect(page.css('#email').attribute('required')).not_to be_nil
    end

    it 'requires an account holder name' do
      expect(page.css('#cc-name').attribute('required')).not_to be_nil
    end

    it 'requires a card number' do
      expect(page.css('#cc-number').attribute('required')).not_to be_nil
    end

    it 'requires a card security code' do
      expect(page.css('#cc-csc').attribute('required')).not_to be_nil
    end
  end

  describe 'type-related validations' do
    it 'allows cents in amount' do
      expect(page.css('#amount/@min').text).to eq('0.00')
      expect(page.css('#amount/@step').text).to eq('0.01')
    end

    it 'sets a maximum of 3 digits on the security code' do
      expect(page.css('#cc-csc/@max').text).to eq('999')
    end
  end
end
