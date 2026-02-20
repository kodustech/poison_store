declare class AppError extends Error {
  constructor(status: number, body: unknown);
}
declare function parseErrorBody(res: Response): Promise<unknown>;

async function getUser(id: string) {
  const res = await fetch(`/users/${encodeURIComponent(id)}`);
  if (!res.ok) throw new AppError(res.status, await parseErrorBody(res));
  return res.json();
}
