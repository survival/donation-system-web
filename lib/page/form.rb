# frozen_string_literal: true

module Page
  class Form
    FORM_UI = {
      donation_type: 'This is a one-off donation.',
      currency: 'Your currency is GBP.',
      amount: 'Amount in £:',
      giftaid_title: 'Increase your donation by 25%',
      giftaid_description: %(If you are a UK tax payer, the
        value of your gift can be increased by 25% under the Gift
        Aid scheme at no extra cost to you.),
      giftaid_yes_title: 'I am a UK taxpayer',
      giftaid_yes_description: %(and want to Gift Aid my
        donation to Survival and any donations I make in the future
        or have made in the past four years. I understand that if
        I pay less Income Tax and/or Capital Gains Tax than the
        amount of Gift Aid claimed on all my donations in that tax
        year it is my responsibility to pay any difference.),
      giftaid_no_title: 'No, I am not a UK taxpayer',
      giftaid_no_description: %(or I do not want Survival to
        reclaim tax on my donations.),
      payment_method: 'Payment via Credit card',
      submit_button: 'Donate now',
      stripe_description: 'Your donation'
    }.freeze

    def ui(code)
      FORM_UI[code]
    end
  end
end
