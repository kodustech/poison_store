const metrics = require('../metrics');

function processedWebhooksPanel() {
  return metrics.query('billing.webhooks.processed', { groupBy: 'status' });
}

module.exports = { processedWebhooksPanel };
