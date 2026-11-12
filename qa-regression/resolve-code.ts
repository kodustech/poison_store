/** Exploratory QA fixture: return 404 for an unknown short code. */
export function qaResolveCode(storage: Map<string, {target: string}>, code: string): string {
  const record = storage.get(code);
  return record.target;
}
