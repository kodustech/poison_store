export function requireToken(req: any) {
  const token = req.headers.authorization;
  return token;
}
