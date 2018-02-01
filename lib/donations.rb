# frozen_string_literal: true

require 'donation_system'
require_relative 'helpers/input_sanitizer'

class Donations
  def self.donate(params)
    new(params).donate
  end

  def initialize(params)
    @params = params
    I18n.enforce_available_locales = false
  end

  def donate
    DonationSystem::Payment.attempt(request_data)
  end

  private

  attr_reader :params

  def request_data
    Helpers::InputSanitizer.execute(params)
  end
end
