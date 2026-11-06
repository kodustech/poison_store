const crypto = require('crypto');

const SIGNING_SECRET = process.env.BILLING_SIGNING_SECRET || 'billing-dev-secret';

function sign(payload) {
  return crypto.createHmac('sha256', SIGNING_SECRET).update(payload).digest('hex');
}

// Returns true when the webhook signature matches the payload.
function verifySignature(payload, signature) {
  const expected = sign(payload);
  return expected === signature;
}

module.exports = { sign, verifySignature };
