/** Pure pricing rules: no framework, no I/O. */
export function lineTotal(unitCents: number, quantity: number): number {
    return unitCents * quantity;
}
