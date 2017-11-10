# frozen_string_literal: true

require 'nokogiri'
require_relative 'donation_data'

module Helpers
  class InputSanitizer
    def self.execute(params)
      new(params).execute
    end

    def initialize(params)
      @params = params
    end

    def execute
      DonationData.new(
        sanitize(:amount), 'gbp', giftaid?, sanitize(:token),
        sanitize(:name),
        sanitize(:email),
        sanitize(:address),
        sanitize(:city),
        sanitize(:state),
        sanitize(:zip),
        sanitize(:country)
      )
    end

    private

    attr_reader :params

    def sanitize(param)
      strip_html_tags(params[param.to_s])
    end

    def strip_html_tags(html)
      Nokogiri::HTML(html).text
    end

    def giftaid?
      sanitize(:giftaid) == 'yes'
    end
  end
end
