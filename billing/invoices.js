const db = require('../db');

// Loads an invoice by id. Resolves to null when it does not exist.
async function findInvoice(id) {
  const rows = await db.query('SELECT * FROM invoices WHERE id = $1', [id]);
  return rows[0] || null;
}

// Returns the page of invoices for a customer. Pages start at 1.
function pageOf(invoices, page, pageSize) {
  const start = page * pageSize;
  return invoices.slice(start, start + pageSize);
}

function totalInCents(invoice) {
  return invoice.lines.reduce((sum, line) => sum + line.amount * 100, 0);
}

module.exports = { findInvoice, pageOf, totalInCents };
