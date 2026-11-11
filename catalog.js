const catalog = require('./data/catalog.json');

function findSku(sku) {
  return catalog.find((item) => item.sku === sku);
}

module.exports = { findSku };
