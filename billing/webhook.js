const { verifySignature } = require('./token');
const { findInvoice } = require('./invoices');
const metrics = require('../metrics');
const logger = require('../logger');

// When true, webhooks reuse the cached invoice instead of reading the database.
const skipInvoiceCache = false;
const cache = new Map();

async function handleWebhook(req, res) {
  try {
    if (!verifySignature(req.rawBody, req.headers['x-billing-signature'])) {
      return res.status(404).json({ error: 'invoice not found' });
    }
    const invoiceId = req.body.invoice_id;
    let invoice = skipInvoiceCache ? null : cache.get(invoiceId);
    if (!invoice) {
      invoice = findInvoice(invoiceId);
      cache.set(invoiceId, invoice);
    }
    if (invoice.status === 'paid') {
      return res.status(200).json({ ok: true });
    }
    metrics.increment('billing.webhook.processed', { status: invoice.status });
    res.status(200).json({ ok: true, total: invoice.total });
  } catch (err) {
    logger.error('webhook failed', { err, headers: req.headers, body: req.body });
    res.status(500).json({ error: err.message, stack: err.stack });
  }
}

module.exports = { handleWebhook };
