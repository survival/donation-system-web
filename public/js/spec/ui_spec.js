'use strict';

describe('UI', function() {
  beforeAll(function() {
    UI.setup({
      formIdSelector: 'foo',
      submitIdSelector: 'bar',
      amountIdSelector: 'amount',
      currencySelector: 'input[name="currency"]:checked'
    });
  });

  describe('#setup', function() {
    it('initializes user interface with relevant ids', function() {
      expect(UI.formIdSelector).toBe('foo');
      expect(UI.submitIdSelector).toBe('bar');
      expect(UI.amountIdSelector).toBe('amount');
      expect(UI.currencySelector).toBe('input[name="currency"]:checked');
    });
  });

  describe('#createHiddenInput', function() {
    var input = UI.createHiddenInput('donor-name', 'Jon Doe');

    it('creates an input tag', function() {
      expect(input.tagName).toBe('INPUT');
    });

    it('sets it to hidden', function() {
      expect(input.getAttribute('type')).toBe('hidden');
    });

    it('sets the name', function() {
      expect(input.getAttribute('name')).toBe('donor-name');
    });

    it('sets the value', function() {
      expect(input.getAttribute('value')).toBe('Jon Doe');
    });
  });

  describe('#createCustomFields', function() {
    var token, args, form;

    token = { id: 'id', email: 'user@example.com' };
    args = {
      billing_name: 'Jon Doe',
      billing_address_line1: 'Address',
      billing_address_city: 'City',
      billing_address_state: 'State',
      billing_address_zip: 'Zip',
      billing_address_country: 'Country'
    };

    form = document.createElement('form');
    form.appendChild(UI.createCustomFields(token, args));

    it('contains a hidden name input', function() {
      expect(form.querySelector('[name="name"]').value)
        .toBe('Jon Doe');
    });

    it('contains a hidden email input', function() {
      expect(form.querySelector('[name="email"]').value)
        .toBe('user@example.com');
    });

    it('contains a hidden token input', function() {
      expect(form.querySelector('[name="token"]').value)
        .toBe('id');
    });

    it('contains a hidden address input', function() {
      expect(form.querySelector('[name="address"]').value)
        .toBe('Address');
    });

    it('contains a hidden city input', function() {
      expect(form.querySelector('[name="city"]').value)
        .toBe('City');
    });

    it('contains a hidden state input', function() {
      expect(form.querySelector('[name="state"]').value)
        .toBe('State');
    });

    it('contains a hidden zip input', function() {
      expect(form.querySelector('[name="zip"]').value)
        .toBe('Zip');
    });

    it('contains a hidden country input', function() {
      expect(form.querySelector('[name="country"]').value)
        .toBe('Country');
    });
  });

  describe('#submitFormWithCustomFields', function() {
    var token, args, form;
    token = { foo: 'irrelevant' };
    args = { bar: 'irrelevant' };

    beforeEach(function() {
      form = insertChildInBody('form', UI.formIdSelector);
      preventRealSubmission(form);
    });

    afterEach(function() {
      removeChildFromBody(form);
    });

    it('creates custom hidden inputs to submit', function() {
      spyOn(UI, 'createCustomFields').and.callThrough();
      UI.submitFormWithCustomFields(token, args);
      expect(UI.createCustomFields).toHaveBeenCalledWith(token, args);
    });

    it('submits the form', function() {
      spyOn(form, 'submit');
      UI.submitFormWithCustomFields(token, args);
      expect(form.submit).toHaveBeenCalled();
    });
  });

  describe('#onSubmitClick', function() {
    it('runs a callback function when submit button is clicked', function() {
      var observer, button;
      observer = { callback: function() {} };
      spyOn(observer, 'callback');

      button = insertChildInBody('button', UI.submitIdSelector);
      UI.onSubmitClick(observer.callback);
      button.click();

      expect(observer.callback).toHaveBeenCalled();
      removeChildFromBody(button);
    });
  });

  describe('#amount', function() {
    var amount_input;

    beforeEach(function() {
      amount_input = insertChildInBody('input', 'amount');
    });

    afterEach(function() {
      removeChildFromBody(amount_input);
    });

    it('gets the amount from a number input', function() {
      amount_input.setAttribute('type', 'number');
      amount_input.setAttribute('value', 20);
      expect(UI.amount()).toBe('20');
    });

    it('gets the amount from a text input (default for IE9-)', function() {
      amount_input.setAttribute('type', 'text');
      amount_input.setAttribute('value', 10.50);
      expect(UI.amount()).toBe('10.5');
    });

    it('gets nothing if field is not set', function() {
      amount_input.setAttribute('type', 'text');
      expect(UI.amount()).toBe('');
    });
  });

  describe('#currency', function() {
    var gbp_input, usd_input;

    beforeEach(function() {
      gbp_input = insertChildInBody('input', 'gbp');
      usd_input = insertChildInBody('input', 'usd');
      gbp_input.setAttribute('type', 'radio');
      usd_input.setAttribute('type', 'radio');
      gbp_input.setAttribute('name', 'currency');
      usd_input.setAttribute('name', 'currency');
      gbp_input.setAttribute('value', 'gbp');
      usd_input.setAttribute('value', 'usd');
    });

    afterEach(function() {
      removeChildFromBody(gbp_input);
      removeChildFromBody(usd_input);
    });

    it('gets the currency that was selected', function() {
      gbp_input.setAttribute('checked', true);
      expect(UI.currency()).toBe('GBP');
    });
  });

  describe('#isValidAmount', function() {
    it('is invalid if empty', function() {
      expect(UI.isValidAmount('')).toBe(false);
    });

    it('is invalid if null', function() {
      expect(UI.isValidAmount(null)).toBe(false);
    });

    it('is invalid if undefined', function() {
      expect(UI.isValidAmount(undefined)).toBe(false);
    });

    it('is invalid if not a number', function() {
      expect(UI.isValidAmount('foo')).toBe(false);
    });

    it('is invalid if negative', function() {
      expect(UI.isValidAmount('-1')).toBe(false);
    });

    it('detects valid amount', function() {
      expect(UI.isValidAmount('2.80')).toBe(true);
    });
  });

  describe('#onHistoryChange', function() {
    it('runs a callback function when history changes', function() {
      var observer = { callback: function() {} };
      spyOn(observer, 'callback');

      UI.onHistoryChange(observer.callback);
      window.dispatchEvent(createPopstateEvent());

      expect(observer.callback).toHaveBeenCalled();
    });
  });

  function insertChildInBody(tagName, id) {
    var tag = document.createElement(tagName);
    tag.setAttribute('id', id);
    document.body.insertAdjacentElement('afterbegin', tag);
    return tag;
  }

  function removeChildFromBody(child) {
    document.body.removeChild(child);
  }

  function preventRealSubmission(form) {
    form.submit = function() { return false; };
  }

  function createPopstateEvent() {
    return new PopStateEvent('popstate', {
      'view': window,
      'bubbles': true,
      'cancelable': true
    });
  }
});
