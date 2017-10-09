# frozen_string_literal: true

require 'spec_helper.rb'

RSpec.describe 'Home page' do
  it 'loads the page' do
    get '/'
    expect(last_response).to be_ok
  end

  it 'loads the donation form' do
    get '/'
    expect(last_response.body).to include('<form')
  end
end
