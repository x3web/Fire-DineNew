(function (root, factory) {
  const api = factory();
  if (typeof module === 'object' && module.exports) module.exports = api;
  root.FireDineBasket = api;
})(typeof globalThis !== 'undefined' ? globalThis : this, function () {
  'use strict';

  const capQuantity = value => Math.max(1, Math.min(99, Number(value) || 1));
  const roundMoney = value => Math.round((Number(value) + Number.EPSILON) * 100) / 100;

  const recalculateItem = item => {
    const quantity = capQuantity(item.quantity);
    const confirmedUnit = item.confirmed_unit_price == null ? null : Number(item.confirmed_unit_price);
    const unit = item.unit_price == null ? null : Number(item.unit_price);
    return {
      ...item,
      quantity,
      confirmed_line_total: confirmedUnit == null ? null : roundMoney(confirmedUnit * quantity),
      line_total: unit == null ? null : roundMoney(unit * quantity),
      pending_price_components: Array.isArray(item.pending_price_components) ? item.pending_price_components : [],
    };
  };

  const basketTotals = items => {
    const recalculated = items.map(recalculateItem);
    const confirmedLines = recalculated.map(item => item.confirmed_line_total).filter(value => value != null);
    return {
      quantity: recalculated.reduce((sum, item) => sum + item.quantity, 0),
      confirmed_total: confirmedLines.length ? roundMoney(confirmedLines.reduce((sum, value) => sum + Number(value), 0)) : null,
      has_pending_price: recalculated.some(item => item.requires_custom_quote || item.pending_price_components.length),
    };
  };

  const mergeItem = (items, incoming) => {
    const next = items.map(recalculateItem);
    const index = next.findIndex(item => item.signature === incoming.signature);
    if (index < 0) next.push(recalculateItem(incoming));
    else next[index] = recalculateItem({...next[index], ...incoming, quantity: capQuantity(next[index].quantity + incoming.quantity)});
    return {items: next, totals: basketTotals(next)};
  };

  return {capQuantity, recalculateItem, basketTotals, mergeItem};
});
