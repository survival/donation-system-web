# frozen_string_literal: true

require_relative 'form'

module Page
  class Error
    ERROR_UI = {
      title: 'Error',
      explanation: 'There was a problem with the processing of your payment',
      retry_message: 'Would you like to try again?'
    }.freeze

    STRIPE_ERRORS = {
      missing_data: 'No data was sent with the request.',
      invalid_amount: 'The amount was missing, or it was not a valid number.',
      invalid_currency: 'The currency was missing, or unrecognizable.',
      missing_token: 'The payment gateway could not process the card details.',
      missing_email: 'The email was missing or had typos.',
      too_many_requests: 'The payment gateway server is busy. Try again later',
      connection_problems: 'We had a problem connecting to the payment gateway',
      stripe_error: 'We had a generic problem with the payment gateway.',
      unknown_error: 'There was an unknown error. Please try again.',
      invalid_api_key: 'The credentials for the payment gateway were invalid',
      invalid_parameter: 'The request contained an invalid parameter',
      declined_card: 'The card was declined by the bank',
      invalid_response_object: 'The payment gateway response was invalid'
    }.freeze

    def initialize(errors)
      @errors = errors
    end

    def title
      ui(:title)
    end

    def ui(code)
      ERROR_UI[code]
    end

    def error_list
      errors.map do |error_code|
        STRIPE_ERRORS.fetch(error_code, error_code.to_s)
      end
    end

    def form
      Form.new
    end

    private

    attr_reader :errors
  end
end
