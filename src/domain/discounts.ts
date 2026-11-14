import type { Request } from 'express';

export function discountPercent(req: Request): number {
    return req.query.code === 'SPRING10' ? 10 : 0;
}
