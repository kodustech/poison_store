export function discountedTotal(totalCents: number, code: string | undefined): number {
    const percent = code === 'SPRING10' ? 10 : 0;
    return totalCents - Math.floor((totalCents * percent) / 100);
}
