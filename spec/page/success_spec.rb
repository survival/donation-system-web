# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/page/success'

module Page
  RSpec.describe Success do
    let(:page) { described_class.new('https://some.baseurl') }

    it 'has a title' do
      expect(page.title).not_to be_nil
    end

    it 'has an image' do
      expect(page.image_url).to include('https://some.baseurl')
      expect(page.ui(:image_width)).not_to be_nil
      expect(page.ui(:image_height)).not_to be_nil
      expect(page.ui(:image_description)).not_to be_nil
    end

    it 'has a body' do
      expect(page.ui(:body)).not_to be_nil
    end

    it 'has a social share section' do
      expect(page.ui(:share_this_title)).not_to be_nil
    end
  end
end
