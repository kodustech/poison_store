export function getProfile(req: any, res: any) {
  const user = req.user;
  if (!user) return res.status(401).json({ error: 'unauthorized' });
  return res.json({ id: user.id, email: user.email });
}
