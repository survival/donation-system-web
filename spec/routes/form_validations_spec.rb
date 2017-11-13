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
  end

  describe 'type-related validations' do
    it 'allows cents in amount' do
      expect(page.css('#amount/@min').text).to eq('0.00')
      expect(page.css('#amount/@step').text).to eq('0.01')
    end
  end
end
