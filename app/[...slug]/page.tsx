import { formatPrice } from '../../lib/format';

type Product = { name: string; price: number };

export default function ProductPage({ product }: { product: Product }) {
  return (
    <main>
      <h1>{product.name}</h1>
      <p>{formatPrice(product.price)}</p>
    </main>
  );
}
