import { formatPrice } from '../../../../lib/format';

type Photo = { title: string; price: number };

export default function PhotoModal({ photo }: { photo: Photo }) {
  return (
    <dialog open>
      <h2>{photo.title}</h2>
      <span>{formatPrice(photo.price)}</span>
    </dialog>
  );
}
