'use strict';

var UI = UI || {};

UI.setup = function(config) {
  UI.formIdSelector = config.formIdSelector;
  UI.submitIdSelector = config.submitIdSelector;
  UI.amountIdSelector = config.amountIdSelector;
  UI.currencySelector = config.currencySelector;
};

UI.createHiddenInput = function(name, value) {
  var input = document.createElement('input');
  input.setAttribute('type', 'hidden');
  input.setAttribute('name', name);
  input.setAttribute('value', value);
  return input;
};

UI.createCustomFields = function(token, args) {
  var fragment = document.createDocumentFragment();
  fragment.appendChild(UI.createHiddenInput('name', args.billing_name));
  fragment.appendChild(UI.createHiddenInput('email', token.email));
  fragment.appendChild(UI.createHiddenInput('token', token.id));
  fragment.appendChild(UI.createHiddenInput('address', args.billing_address_line1));
  fragment.appendChild(UI.createHiddenInput('city', args.billing_address_city));
  fragment.appendChild(UI.createHiddenInput('state', args.billing_address_state));
  fragment.appendChild(UI.createHiddenInput('zip', args.billing_address_zip));
  fragment.appendChild(UI.createHiddenInput('country', args.billing_address_country));
  return fragment;
};

UI.submitFormWithCustomFields = function(token, args) {
  var form = document.getElementById(UI.formIdSelector);
  form.appendChild(UI.createCustomFields(token, args));
  form.submit();
};

UI.onButtonClick = function(callback) {
  var submitButton = document.getElementById(UI.submitIdSelector);
  submitButton.addEventListener('click', callback);
};

UI.amount = function() {
  return document.getElementById(UI.amountIdSelector).value;
};

UI.currency = function() {
  return document.querySelector(UI.currencySelector).value.toUpperCase();
};

UI.isValidAmount = function(amount) {
  var numeric_amount = parseFloat(amount);
  return !isNaN(numeric_amount) && isFinite(numeric_amount) && numeric_amount > 0.0;
};

UI.onHistoryChange = function(callback) {
  window.addEventListener('popstate', callback);
};
