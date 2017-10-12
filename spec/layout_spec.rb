# frozen_string_literal: true

require 'spec_helper.rb'

RSpec.describe 'Home page' do
  before(:all) { get '/' }

  def page
    @page ||= Nokogiri::HTML(last_response.body)
  end

  it 'loads the page' do
    expect(last_response).to be_ok
  end

  it 'loads the donation form' do
    expect(last_response.body).to include('<form')
  end

  describe 'amount section' do
    it 'displays a donation type' do
      expect(last_response.body).to include('one-off')
    end

    it 'displays a donation currency' do
      expect(last_response.body).to include('GBP')
    end

    it 'displays a donation amount' do
      expect(page.css('input#amount').count).to be(1)
    end
  end

  describe 'gift aid section' do
    it 'displays a gift aid selector' do
      expect(page.css('input#gift-aid-yes').count).to be(1)
      expect(page.css('input#gift-aid-no').count).to be(1)
    end
  end

  describe 'payment information section' do
    it 'displays a payment type selector' do
      expect(last_response.body).to include('Credit card')
    end

    describe 'contact details section' do
      it 'displays a name field' do
        expect(page.css('input#name').count).to be(1)
      end

      it 'displays an email field' do
        expect(page.css('input#email').count).to be(1)
      end
    end

    describe 'card details section' do
      it 'displays a name on card field' do
        expect(page.css('input#cc-name').count).to be(1)
      end

      it 'displays a credit card field' do
        expect(page.css('input#cc-number').count).to be(1)
      end

      it 'displays expiry date fields' do
        expect(page.css('select#cc-exp-month').count).to be(1)
        expect(page.css('select#cc-exp-year').count).to be(1)
      end

      it 'displays a security code field' do
        expect(page.css('input#cc-csc').count).to be(1)
      end
    end
  end

  it 'displays the submit button' do
    expect(page.css('#submit').count).to be(1)
  end
end
