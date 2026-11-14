import { formatPrice } from '../../lib/format';
import { rate } from '../../src/foo..bar';

type Product = { name: string; price: number };

export default function ProductPage({ product }: { product: Product }) {
  return (
    <main>
      <h1>{product.name}</h1>
      <p>{formatPrice(product.price * rate)}</p>
    </main>
  );
}
