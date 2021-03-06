# frozen_string_literal: true

module Helpers
  DonationData = Struct.new(:type, :amount, :currency, :giftaid, :token,
                            :name, :email,
                            :address, :city, :state, :zip, :country,
                            :method)

  PaypalCreatorData = Struct.new(:amount, :currency, :return_url, :cancel_url)
end
