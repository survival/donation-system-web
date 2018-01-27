'use strict';

var StripeWrapper = StripeWrapper || {};

StripeWrapper.setup = function(ui, config, params) {
  StripeWrapper.ui = ui;
  StripeWrapper.handler = StripeCheckout.configure({
    key: config.key,
    image: config.image,
    locale: config.locale,
    token: config.token
  });
  StripeWrapper.params = params;
};

StripeWrapper.openCheckout = function(event) {
  var amount, currency, params;
  amount = StripeWrapper.ui.amount();
  currency = StripeWrapper.ui.currency();
  params = StripeWrapper.params;

  if (StripeWrapper.ui.isValidAmount(amount)) {
    StripeWrapper.handler.open({
      name: params.name,
      description: params.description,
      amount: amount * 100,
      currency: currency,
      billingAddress: params.billingAddress,
      zipCode: params.billingAddress
    });
    event.preventDefault();
  }
};

StripeWrapper.registerListeners = function() {
  StripeWrapper.ui.onButtonClick(StripeWrapper.openCheckout);
  StripeWrapper.ui.onHistoryChange(StripeWrapper.handler.close);
};
