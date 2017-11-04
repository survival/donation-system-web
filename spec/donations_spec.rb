# frozen_string_literal: true

require 'spec_helper.rb'

RSpec.describe 'Donations' do
  it 'receives parameters' do
    post '/donations', 'foo' => 'bar', 'bar' => 'qux'
    expect(last_response.body).to include('foo: bar')
    expect(last_response.body).to include('bar: qux')
  end
end
