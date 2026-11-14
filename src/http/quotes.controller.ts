import { lineTotal } from '../domain/pricing';
import { discountedTotal } from '../domain/discounts';

export function quote(req: any, res: any) {
    const total = lineTotal(Number(req.query.unitCents), Number(req.query.quantity));
    const code = typeof req.query.code === 'string' ? req.query.code : undefined;
    res.json({ totalCents: discountedTotal(total, code) });
}
