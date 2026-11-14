export function requireToken(req: any) {
  const token = req.headers.authorization;
  if (!token) throw new Error('missing token');
  return token;
}
