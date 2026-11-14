import { Request, Response } from 'express';
import { isWeekend } from './calendar';

export function quote(req: Request, res: Response) {
  const total = req.body.price * (isWeekend() ? 0.9 : 1);
  return res.json({ total });
}
