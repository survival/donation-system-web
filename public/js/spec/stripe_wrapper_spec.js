'use strict';

describe('StripeWrapper', function() {
  describe('#setup', function() {
    it('sets the UI to use', function() {
      StripeWrapper.setup(UI, {}, {});
      expect(StripeWrapper.ui).toBe(UI);
    });

    it('initializes Checkout with relevant options', function() {
      var config = {
        key: 'foo',
        image: 'bar',
        locale: 'es',
        token: function() {}
      };

      spyOn(StripeCheckout, 'configure');
      StripeWrapper.setup(UI, config, {});
      expect(StripeCheckout.configure).toHaveBeenCalledWith(config);
    });

    it('sets the params for the Checkout pop up', function() {
      var params = { foo: 'irrelevant' };
      StripeWrapper.setup(UI, {}, params);
      expect(StripeWrapper.params).toBe(params);
    });
  });

  describe('#openCheckout', function() {
    var validAmountUIFake, invalidAmountUIFake, clickEvent;

    beforeAll(function() {
      validAmountUIFake = {
        amount: function() { return '20'; },
        currency: function() { return 'GBP'; },
        isValidAmount: function() { return true; }
      };
      invalidAmountUIFake = {
        amount: function() { return 'foo'; },
        currency: function() { return 'GBP'; },
        isValidAmount: function() { return false; }
      };
      clickEvent = createClickEvent();
    });

    it('does not open Checkout pop up if amount is invalid', function() {
      StripeWrapper.setup(invalidAmountUIFake, {}, {});
      spyOn(StripeWrapper.handler, 'open').and.callThrough();

      StripeWrapper.openCheckout(clickEvent);

      expect(StripeWrapper.handler.open).not.toHaveBeenCalled();
    });

    it('opens Checkout pop up if amount is valid', function() {
      StripeWrapper.setup(validAmountUIFake, {}, {});
      StripeWrapper.handler.open = function() {};
      spyOn(StripeWrapper.handler, 'open').and.callThrough();

      StripeWrapper.openCheckout(clickEvent);

      expect(StripeWrapper.handler.open).toHaveBeenCalled();
    });

    it('passes params to Checkout pop up', function() {
      var params, paramsSent;
      params = {
        name: 'Name',
        description: 'description',
        billingAddress: true,
        zipCode: true
      };
      paramsSent = params;
      paramsSent.amount = 2000;
      paramsSent.currency = 'GBP';

      StripeWrapper.setup(validAmountUIFake, {}, params);
      StripeWrapper.handler.open = function() {};
      spyOn(StripeWrapper.handler, 'open').and.callThrough();

      StripeWrapper.openCheckout(clickEvent);

      expect(StripeWrapper.handler.open).toHaveBeenCalledWith(paramsSent);
    });

    it('prevents form submission', function() {
      StripeWrapper.setup(validAmountUIFake, {}, {});
      StripeWrapper.handler.open = function() {};
      spyOn(clickEvent, 'preventDefault');

      StripeWrapper.openCheckout(clickEvent);

      expect(clickEvent.preventDefault).toHaveBeenCalled();
    });
  });

  describe('#registerListeners', function() {
    var ui;

    beforeAll(function() {
      ui = {
        onSubmitClick: function() {},
        onHistoryChange: function() {}
      };
    });

    it('registers a click listener', function() {
      spyOn(ui, 'onSubmitClick');
      StripeWrapper.setup(ui, {}, {});
      StripeWrapper.registerListeners();
      expect(ui.onSubmitClick).toHaveBeenCalledWith(StripeWrapper.openCheckout);
    });

    it('registers a history change listener', function() {
      spyOn(ui, 'onHistoryChange');
      StripeWrapper.setup(ui, {}, {});
      StripeWrapper.registerListeners();
      expect(ui.onHistoryChange).toHaveBeenCalledWith(StripeWrapper.handler.close);
    });
  });

  function createClickEvent() {
    return new MouseEvent('click', {
      'view': window,
      'bubbles': true,
      'cancelable': true
    });
  }
});
