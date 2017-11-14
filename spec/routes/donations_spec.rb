# frozen_string_literal: true

require 'spec_helper.rb'

RSpec.describe 'Donations route' do
  describe 'when successful' do
    before do
      allow(Donations).to receive(:donate).and_return([])
      post '/donations', 'foo' => 'bar', 'bar' => 'qux'
    end

    it 'makes a donation' do
      expect(Donations).to have_received(:donate)
        .with('foo' => 'bar', 'bar' => 'qux')
    end

    it 'loads success page' do
      expect(last_response.body).to include('Thanks')
    end
  end

  describe 'when unsuccessful' do
    before(:all) { post '/donations', 'foo' => 'bar', 'bar' => 'qux' }

    it 'sends errors to the view' do
      expect(last_response.body).to include('invalid_amount')
    end

    it 'loads the donation form' do
      expect(last_response.body).to include('<form')
    end
  end
end
