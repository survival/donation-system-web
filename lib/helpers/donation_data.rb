# frozen_string_literal: true

module Helpers
  DonationData = Struct.new(:amount, :currency, :giftaid, :token,
                            :name, :email,
                            :address, :city, :state, :zip, :country)
end
