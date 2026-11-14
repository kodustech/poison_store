import { slugify } from './slug';

test('slugify lowercases and joins words', () => {
  expect(slugify(' Hello World ')).toBe('hello-world');
});

test('slugify drops leading and trailing separators', () => {
  expect(slugify('--Hi--')).toBe('hi');
});
