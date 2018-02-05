# frozen_string_literal: true

require 'nokogiri'
require_relative 'donation_data'

module Helpers
  class PaypalCreatorDataSanitizer
    def self.execute(params)
      new(params).execute
    end

    def initialize(params)
      @params = params
    end

    def execute
      PaypalCreatorData.new(
        sanitize(:amount),
        sanitize(:currency),
        sanitize(:return_url),
        sanitize(:cancel_url)
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
  end
end
