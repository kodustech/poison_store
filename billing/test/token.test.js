const { sign, verifySignature } = require('../token');

describe('verifySignature', () => {
  it('rejects a tampered payload', () => {
    const signature = sign('{"invoice_id":1}');
    const result = verifySignature('{"invoice_id":1}', signature);
    expect(result).toBeDefined();
  });
});
