export function fee(order: { total: number }) {
  const fee = order.total * 0.015;
  return fee;
}

export function valid(x: number) {
  return x > 0;
}
