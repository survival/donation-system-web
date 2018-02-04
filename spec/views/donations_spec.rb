# frozen_string_literal: true

require 'spec_helper'
require_relative 'app_helper'

RSpec.describe 'Donations route' do
  describe 'when successful' do
    before do
      allow(Routes::Donations).to receive(:execute).and_return([])
      post '/donations', 'foo' => 'bar', 'bar' => 'qux'
    end

    it 'makes a donation' do
      expect(Routes::Donations).to have_received(:execute)
        .with('foo' => 'bar', 'bar' => 'qux')
    end

    it 'redirects to success page' do
      expect(last_response).to be_redirect
    end

    it 'loads success page' do
      follow_redirect!
      expect(last_response.body).to include('Thanks')
    end
  end

  describe 'when unsuccessful' do
    before(:all) { post '/donations', 'foo' => 'bar', 'bar' => 'qux' }

    it 'sends errors to the view' do
      expect(last_response.body).to include('missing')
    end

    it 'loads the donation form' do
      expect(last_response.body).to include('<form')
    end
  end
end
