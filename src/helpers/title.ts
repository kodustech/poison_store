import { slugify } from './slug';

export function titleToPath(title: string): string {
  return `/posts/${slugify(title)}`;
}
