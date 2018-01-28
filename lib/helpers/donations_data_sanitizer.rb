# frozen_string_literal: true

require 'nokogiri'
require_relative 'donation_data'

module Helpers
  class DonationsDataSanitizer
    PAYPAL_TOKEN_SEPARATOR = ','

    def self.execute(params)
      new(params).execute
    end

    def initialize(params)
      @params = params
    end

    def execute
      DonationData.new(
        sanitize(:type), sanitize(:amount), sanitize(:currency), giftaid?,
        token, sanitize(:name), sanitize(:email),
        sanitize(:address),
        sanitize(:city),
        sanitize(:state),
        sanitize(:zip),
        sanitize(:country),
        sanitize(:method)
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

    def paypal?
      sanitize(:method) == 'paypal'
    end

    def token
      token = sanitize(:token)
      return token unless paypal?
      payment_id, payer_id = token.split(PAYPAL_TOKEN_SEPARATOR)
      PaypalToken.new(payment_id, payer_id)
    end

    PaypalToken = Struct.new(:payment_id, :payer_id)
  end
end
