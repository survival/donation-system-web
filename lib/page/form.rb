# frozen_string_literal: true

module Page
  class Form
    FORM_UI = {
      oneoff_type: 'One-time donation',
      recurring_type: 'Recurring donation',
      currency: 'Currency',
      currencies: [
        { label: '£', value: 'gbp' },
        { label: '$', value: 'usd' }
      ],
      amount: 'Amount:',
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
      payment_method: 'Select your payment method',
      stripe_label: 'Credit or debit card',
      paypal_label: 'PayPal',
      stripe_description: 'Your donation',
      frequency_title: 'Select your frequency',
      frequency: 'When to donate:',
      month_label: 'Monthly',
      quarter_label: 'Quarterly',
      year_label: 'Yearly',
      join_title: 'Join the movement',
      join_description: %(Help us prevent the anihilation of
        tribal peoples. Hear all about our latest campaign and
        how you can support our groundbreaking work.),
      submit_button: 'Donate now'
    }.freeze

    def ui(code)
      FORM_UI[code]
    end
  end
end
