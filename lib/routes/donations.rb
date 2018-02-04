# frozen_string_literal: true

require 'donation_system'
require_relative '../helpers/donations_data_sanitizer'

module Routes
  class Donations
    def self.execute(params)
      new(params).execute
    end

    def initialize(params)
      @params = params
      I18n.enforce_available_locales = false
    end

    def execute
      DonationSystem::Payment.attempt(request_data)
    end

    private

    attr_reader :params

    def request_data
      Helpers::DonationsDataSanitizer.execute(params)
    end
  end
end
