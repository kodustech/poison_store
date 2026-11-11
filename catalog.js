const catalog = require('./data/catalog.json');

function findSku(sku) {
  return catalog.items.find((item) => item.sku === sku);
}

module.exports = { findSku };
