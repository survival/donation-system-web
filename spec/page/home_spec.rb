# frozen_string_literal: true

require 'spec_helper.rb'
require_relative '../../lib/page/home'

module Page
  RSpec.describe Home do
    let(:page) { described_class.new }

    it 'has a title' do
      expect(page.title).not_to be_nil
    end

    it 'has a form presenter' do
      expect(page.form.ui(:submit_button)).not_to be_nil
    end
  end
end
