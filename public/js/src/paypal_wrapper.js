'use strict';

var PaypalWrapper = PaypalWrapper || {};

PaypalWrapper.setup = function(ui, config) {
  PaypalWrapper.ui = ui;
  PaypalWrapper.config = config;
  PaypalWrapper.button = paypal.Button;
  PaypalWrapper.request = paypal.request;
};

PaypalWrapper.payment = function() {
  var params = {
    amount: PaypalWrapper.ui.amount(),
    currency: PaypalWrapper.ui.currency()
  };

  if (PaypalWrapper.ui.isValidAmount(params.amount)) {
    return PaypalWrapper.request
      .post(PaypalWrapper.config.create_url, params)
      .then(function(response) { return response.id; })
      .catch(function() { PaypalWrapper.ui.submitFormWithCustomFields({}, {}); });
  }
};

PaypalWrapper.onAuthorize = function(data) {
  var token = { id: data.paymentID + PaypalWrapper.config.token_separator + data.payerID };
  PaypalWrapper.ui.submitFormWithCustomFields(token, {});
};

PaypalWrapper.registerListeners = function() {
  PaypalWrapper.button.render({
    env: PaypalWrapper.config.env,
    commit: true,
    style: PaypalWrapper.config.style,
    payment: PaypalWrapper.payment,
    onAuthorize: PaypalWrapper.onAuthorize
  }, '#' + PaypalWrapper.ui.paypalButtonIdSelector);
};
