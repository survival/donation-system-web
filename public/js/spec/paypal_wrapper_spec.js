'use strict';

describe('PaypalWrapper', function() {
  var ui, config;
  ui = {
    paypalButtonIdSelector: 'paypal-button',
    amount: function() { return '5.50'; },
    currency: function() { return 'gbp'; },
    isValidAmount: function() { return true; },
    submitFormWithCustomFields: function() {}
  };
  config = {
    env: 'sandbox',
    style:  { key: 'value' },
    create_url: 'http://create.com',
    return_url: 'http://return.com',
    cancel_url: 'http://cancel.com',
    token_separator: ','
  };

  beforeEach(function() {
    PaypalWrapper.setup(ui, config);
  });

  describe('#setup', function() {
    it('sets the UI to use', function() {
      PaypalWrapper.setup(UI, {});
      expect(PaypalWrapper.ui).toBe(UI);
    });

    it('sets Paypal specific congiguration options', function() {
      var config = { foo: 'irrelevant' };
      PaypalWrapper.setup('irrelevant', config);
      expect(PaypalWrapper.config).toBe(config);
    });

    it('sets the Paypal button', function() {
      PaypalWrapper.setup('irrelevant', {});
      expect(PaypalWrapper.button).toBeDefined();
    });

    it('sets the Paypal request', function() {
      PaypalWrapper.setup('irrelevant', {});
      expect(PaypalWrapper.request).toBeDefined();
    });
  });

  describe('#payment', function() {
    it('makes a post request to the creation url', function() {
      spyOn(PaypalWrapper.request, 'post').and.callThrough();
      PaypalWrapper.payment();
      expect(PaypalWrapper.request.post)
        .toHaveBeenCalledWith('http://create.com', jasmine.any(Object));
    });

    it('passes the creation params to the post request', function() {
      var params = { amount: '5.50', currency: 'gbp' };
      spyOn(PaypalWrapper.request, 'post').and.callThrough();
      PaypalWrapper.payment();
      expect(PaypalWrapper.request.post)
        .toHaveBeenCalledWith('http://create.com', params);
    });

    it('returns the payment id back to the Paypal library', function() {
      var response = { id: 'id' };
      spyOn(PaypalWrapper.request, 'post').and.returnValue(Promise.resolve(response));
      PaypalWrapper.payment().then(function(result) {
        expect(result).toBe('id');
      });
    });

    it('submits the form if the request failed', function() {
      spyOn(PaypalWrapper.request, 'post').and.returnValue(Promise.reject());
      spyOn(PaypalWrapper.ui, 'submitFormWithCustomFields');
      PaypalWrapper.payment().then(function() {
        expect(PaypalWrapper.ui.submitFormWithCustomFields)
          .toHaveBeenCalledWith({}, {});
      });
    });

    it('does not return if amount is invalid', function() {
      var badUI = {
        amount: function() { return '-1'; },
        currency: function() { return 'gbp'; },
        isValidAmount: function() { return false; }
      };
      PaypalWrapper.setup(badUI, config);
      spyOn(PaypalWrapper.request, 'post').and.callThrough();
      PaypalWrapper.payment();
      expect(PaypalWrapper.request.post).not.toHaveBeenCalled();
    });
  });

  describe('#onAuthorize', function() {
    it('submits form with a token that includes payment and payer ids', function() {
      spyOn(PaypalWrapper.ui, 'submitFormWithCustomFields');
      PaypalWrapper.onAuthorize({ paymentID: 'PAY-1234', payerID: '5678'});
      expect(PaypalWrapper.ui.submitFormWithCustomFields)
        .toHaveBeenCalledWith({id: 'PAY-1234,5678'}, {});
    });
  });

  describe('#registerListeners', function() {
    it('renders the Paypal button', function() {
      spyOn(PaypalWrapper.button, 'render');
      PaypalWrapper.registerListeners();
      expect(PaypalWrapper.button.render).toHaveBeenCalled();
    });

    it('passes the config params', function() {
      var params = {
        env: 'sandbox',
        commit: true,
        style: { key: 'value' },
        payment: PaypalWrapper.payment,
        onAuthorize: PaypalWrapper.onAuthorize
      };
      spyOn(PaypalWrapper.button, 'render');
      PaypalWrapper.registerListeners();
      expect(PaypalWrapper.button.render)
        .toHaveBeenCalledWith(params, jasmine.any(String));
    });

    it('passes the button id selector', function() {
      spyOn(PaypalWrapper.button, 'render');
      PaypalWrapper.registerListeners();
      expect(PaypalWrapper.button.render)
        .toHaveBeenCalledWith(jasmine.any(Object), '#paypal-button');
    });
  });
});
