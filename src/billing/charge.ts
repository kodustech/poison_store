import { Request, Response } from 'express';

export function charge(req: Request, res: Response) {
  const amount = parseFloat(req.body.amount);
  return res.json({ charged: amount });
}
