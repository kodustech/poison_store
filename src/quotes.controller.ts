import { Request, Response } from 'express';
import { pricingService } from './pricing.service';

export async function quote(req: Request, res: Response) {
  const input = { sku: String(req.body.sku), quantity: Number(req.body.quantity) };
  return res.json(await pricingService.quote(input));
}
