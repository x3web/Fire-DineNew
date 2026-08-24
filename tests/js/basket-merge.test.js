'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const {mergeItem} = require('../../public/assets/js/basket-calculations.js');

test('merging quantity 60 with quantity 60 caps at 99 and recalculates every total', () => {
  const base = {
    signature: 'same-configuration',
    product_id: 98,
    quantity: 60,
    confirmed_unit_price: 18900,
    unit_price: 18900,
    confirmed_line_total: 1134000,
    line_total: 1134000,
    requires_custom_quote: false,
    pending_price_components: [],
  };
  const result = mergeItem([base], {...base});
  assert.equal(result.items.length, 1);
  assert.equal(result.items[0].quantity, 99);
  assert.equal(result.items[0].confirmed_line_total, 1871100);
  assert.equal(result.items[0].line_total, 1871100);
  assert.equal(result.totals.quantity, 99);
  assert.equal(result.totals.confirmed_total, 1871100);
  assert.equal(result.totals.has_pending_price, false);
});

test('pending-price components survive a merge and confirmed components are recalculated', () => {
  const item = {
    signature: 'pending-configuration',
    quantity: 60,
    confirmed_unit_price: 650,
    unit_price: null,
    confirmed_line_total: 39000,
    line_total: null,
    requires_custom_quote: true,
    pending_price_components: [{type:'option', label:'Mosaic'}],
  };
  const result = mergeItem([item], {...item});
  assert.equal(result.items[0].quantity, 99);
  assert.equal(result.items[0].confirmed_line_total, 64350);
  assert.equal(result.items[0].line_total, null);
  assert.deepEqual(result.items[0].pending_price_components, [{type:'option', label:'Mosaic'}]);
  assert.equal(result.totals.confirmed_total, 64350);
  assert.equal(result.totals.has_pending_price, true);
});
