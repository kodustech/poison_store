export function getProfile(req: any, res: any) {
  const user = req.user;
  return res.json({ id: user.id, email: user.email });
}
