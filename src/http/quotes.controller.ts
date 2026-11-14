import { lineTotal } from '../domain/pricing';

export function quote(req: any, res: any) {
    res.json({ totalCents: lineTotal(Number(req.query.unitCents), Number(req.query.quantity)) });
}
